"
A editor stack view that provides a list od open editors.
Editors can be sorted in diferent ways (open time, last activated time...). Default one is ""open time""
"
Class {
	#name : 'PulsarStackView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'mutex',
		'countPresenter',
		'sortingSelector'
	],
	#category : 'Pulsar-Browser-View-Stack',
	#package : 'Pulsar-Browser',
	#tag : 'View-Stack'
}

{ #category : 'defaults' }
PulsarStackView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
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

{ #category : 'initialization' }
PulsarStackView >> addCountPresenter [
	
	toolbarPresenter addPresenter: (countPresenter := self newLabel
		addStyle: 'count';
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself)
]

{ #category : 'initialization' }
PulsarStackView >> addSortingToolbar [
	| firstActivationTime lastActivationTime |
	
	firstActivationTime := self newToggleButton
		addStyle: 'flat';
		icon: (self iconNamed: #firstActivationTime);
		help: 'Toggle sorting by first activation time';
		state: (self isSortingBy: #firstActivationTime);
		whenActivatedDo: [ self doSortBy: #firstActivationTime ];
		yourself.
	lastActivationTime := self newToggleButton
		addStyle: 'flat';
		icon: (self iconNamed: #lastActivationTime);
		help: 'Toggle sorting by last activation time';
		state: (self isSortingBy: #lastActivationTime);
		whenActivatedDo: [ self doSortBy: #lastActivationTime ];
		yourself.
		
	firstActivationTime associatedToggleButtons: { lastActivationTime }.
	
	toolbarPresenter addPresenter: (self newToolbar
		displayMode: self application toolbarDisplayMode;
		add: firstActivationTime;
		add: lastActivationTime;
		yourself)
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

{ #category : 'private - actions' }
PulsarStackView >> doSortBy: aSelector [
	| item |

	item := listPresenter selectedItem.
	sortingSelector := aSelector.
	self updatePresenter.
	item ifNotNil: [
		listPresenter selectItem: item ]
]

{ #category : 'private' }
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
	self mutex critical: [
		self updatePresenter.
		activatedEditor withPanelWindowDo: [ :w | 
			w isClosed 
				ifTrue: [ ^ self ] ].
		listPresenter selectItem: activatedEditor model ]
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

{ #category : 'private' }
PulsarStackView >> firstActivationTime: aCollection [ 

	^ aCollection reversed
]

{ #category : 'initialization' }
PulsarStackView >> initialize [

	sortingSelector := #firstActivationTime.
	super initialize
]

{ #category : 'initialization' }
PulsarStackView >> initializePresenters [

	self addStyle: 'pulsarStack'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #editorStackGeneral).
	self addSortingToolbar.
	self addCountPresenter.
	
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

{ #category : 'private - testing' }
PulsarStackView >> isSortingBy: aSelector [

	^ sortingSelector = aSelector
]

{ #category : 'private' }
PulsarStackView >> lastActivationTime: aCollection [ 

	^ aCollection sorted: [ :a | a presenter lastTimePresented ] descending
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

{ #category : 'private' }
PulsarStackView >> shownEditors [
	| editors |

	editors := self sortEditors: (self window editors reject: [ :each | each isClosed ]).
	^ editors collect: [ :each | each presenter model ]
]

{ #category : 'private' }
PulsarStackView >> sortEditors: aCollection [

	^ self perform: sortingSelector asMutator with: aCollection 
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
