Class {
	#name : 'PulsarStackView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'mutex',
		'countPresenter'
	],
	#category : 'Pulsar-Browser-View-Stack',
	#package : 'Pulsar-Browser',
	#tag : 'View-Stack'
}

{ #category : 'defaults' }
PulsarStackView class >> defaultPulsarPosition [

	^ SpPanelPosition new 
		area: SpPanelArea start;
		row: 2;
		yourself
]

{ #category : 'accessing - actions' }
PulsarStackView class >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder 
		addGroup: #editorStack with: [ :group | group
			priority: 10;
			beDisplayedAsGroup;
			addActionWith: [ :action | action
				name: 'Close Selected Editors';
				description: 'Close selected editors';
				iconName: 'close';
				shortcutKey: $x mod1;
				action: [ :aContext | aContext doCloseSelectedEditors ] ] ];
		addGroup: #editorStackGeneral with: [ :group | group
			priority: 1000;
			beDisplayedAsGroup;
			addActionWith: [ :action | action
				name: 'Close All';
				description: 'Close all editors';
				iconName: 'closeAll';
				action: [ :aContext | aContext doCloseEditors ] ] ]
]

{ #category : 'private - actions' }
PulsarStackView >> closeEditor: aModel [

	aModel ifNil: [ ^ self ].
	
	logger trace: aModel.
	self notificationCenter announce: (PulsarModelDeactivated newValue: aModel realModel)
]

{ #category : 'private - actions' }
PulsarStackView >> closeEditors: aCollection [

	logger trace: aCollection.

	"just one if we selected just one :)"
	aCollection size = 1 
		ifTrue: [ self closeEditor: aCollection anyOne ].
		
	self notificationCenter 
		announce: (PulsarManyModelDeactivated newValue: (aCollection collect: #realModel))
]

{ #category : 'layout' }
PulsarStackView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - actions' }
PulsarStackView >> doCloseEditors [
	 
	self closeEditors: listPresenter items copy
]

{ #category : 'private - actions' }
PulsarStackView >> doCloseSelectedEditors [
	
	self closeEditors: listPresenter selectedItems copy
]

{ #category : 'initialization' }
PulsarStackView >> editorCount [
	| shownSize fullSize |

	fullSize := listPresenter unfilteredItems size.
	fullSize = 0 ifTrue: [ ^ '' ].
	shownSize := listPresenter items size.	
	^ shownSize = fullSize
		ifTrue: [ shownSize asString ]
		ifFalse: [ '{1} / {2}' format: { shownSize. fullSize } ]
]

{ #category : 'events' }
PulsarStackView >> eventContextChanged: anAnnouncement [

	self updatePresenter
]

{ #category : 'events' }
PulsarStackView >> eventEditorActivated: anAnnouncement [
	| currentItem activatedEditor |

	activatedEditor := anAnnouncement value. 
	
	"if is closed (it may happen when closing many editors that I receive an activation
	 that will immediately be closed), then I need just to update in order to refresh 
	 the list and return. "
	activatedEditor withPanelWindowDo: [ :w | 
		w isClosed ifTrue: [
			self updatePresenter.
			^ self ] ].

	"get the item in list (just to know if we have it in the list"
	currentItem := listPresenter items
		detect: [ :each | each = activatedEditor model ]
		ifNone: [ nil ].
		
	"if it is already there, I just need to select it"
	currentItem ifNotNil: [
		self mutex critical: [
			listPresenter selectedItem ifNotNil: [ listPresenter unselectAll ].
			listPresenter selectItem: currentItem ]. 
		^ self ].

	"not there, I need to refresh the list and select it (unselectAll because 
	 this is a multi selection list."
	self updatePresenter.
	self mutex critical: [
		listPresenter selectedItem ifNotNil: [ listPresenter unselectAll ].
		listPresenter selectItem: anAnnouncement value model ]
]

{ #category : 'events' }
PulsarStackView >> eventEditorClosed: anAnnouncement [
	
	"this just has sense if this is the last one, because all the others will be 
	 processed when autoselect the next editor"
	"listPresenter items size > 1 ifTrue: [ ^ self ]."
	self updatePresenter
]

{ #category : 'events' }
PulsarStackView >> eventModelChanged: anAnnouncement [
	
	"if name changed, I will need to show the change"
	(anAnnouncement oldEntity isNil 
		or: [ anAnnouncement value fullName = anAnnouncement oldEntity fullName ]) 
		ifTrue: [ ^ self ].
	
	self updatePresenter
]

{ #category : 'initialization' }
PulsarStackView >> initializePresenters [

	self addStyle: 'dockStack'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #editorStackGeneral).
	toolbarPresenter addPresenter: (countPresenter := self newLabel
		addStyle: 'count';
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself).
	
	listPresenter := self newFilteringList
		addStyle: 'stList';
		beMultipleSelection;
		rowPresenterClass: PulsarStackRow;
		display: [ :aContextModel | aContextModel fullName ];
		actions: (self actions actionsForAll: #(editorStack editorStackGeneral));
		whenFilterChangedDo: [ self updateCount ];
		yourself
]

{ #category : 'initialization' }
PulsarStackView >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Editor Stack'";
		windowIcon: (self iconNamed: 'editorStack')"
]

{ #category : 'private' }
PulsarStackView >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private - announcing' }
PulsarStackView >> notifySelectEntity: aCollection [

	aCollection ifEmpty: [ ^ self ].
	self notificationCenter 
		announce: aCollection first newSelectionAnnouncement
]

{ #category : 'initialization' }
PulsarStackView >> registerToEvents [

	self announcer 
		when: PulsarEditorActivated send: #eventEditorActivated: to: self;
		when: PulsarToolEditorActivated send: #eventEditorActivated: to: self;
		when: PulsarEditorClosed send: #eventEditorClosed: to: self;
		when: PulsarModelChanged send: #eventModelChanged: to: self;
		when: PulsarDebuggerContextChanged send: #eventContextChanged: to: self
]

{ #category : 'initialization' }
PulsarStackView >> shownEditors [

	^ (self window editors 
		reject: [ :each | each isClosed ]
			thenCollect: [ :each | each presenter model ]) 
			reversed
]

{ #category : 'initialization' }
PulsarStackView >> updateCount [

	countPresenter label: self editorCount
]

{ #category : 'initialization' }
PulsarStackView >> updatePresenter [

	self window ifNil: [ ^ self ].
	"it may be that the editor is being closed when the update is triggered.
	 and several events may trigger a new update."
	self mutex critical: [
		listPresenter updateItemsKeepingSelection: self shownEditors.
		self updateCount ]
]
