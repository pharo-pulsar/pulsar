Class {
	#name : 'DockStackView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Dock-Browser-View-Stack',
	#package : 'Dock-Browser',
	#tag : 'View-Stack'
}

{ #category : 'defaults' }
DockStackView class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea start;
		row: 2;
		yourself
]

{ #category : 'as yet unclassified' }
DockStackView class >> defineActionGroupGeneral: actionGroup [
	<perspectiveActionGroup: #editorStackGeneral>
	
	actionGroup
		priority: 1000;
		beDisplayedAsGroup
]

{ #category : 'as yet unclassified' }
DockStackView class >> defineActionGroupStack: actionGroup [
	<perspectiveActionGroup: #editorStack>
	
	actionGroup
		priority: 10;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockStackView class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder 
		registerGroup: #editorStack with: { 
			$x mod1 -> (PvAction new 
				name: 'Close selected editors';
				description: 'Close selected editors';
				action: [ :aContext | aContext doCloseSelectedEditors ];
				yourself).
		};
		registerGroup: #editorStackGeneral with: {
			PvAction new 
				name: 'Close All';
				description: 'Close all editors';
				iconCompositeName: 'delete';
				action: [ :aContext | aContext doCloseEditors ];
				yourself.
		}
	
]

{ #category : 'private - actions' }
DockStackView >> closeEditor: aModel [

	aModel ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelDeactivated newValue: aModel realModel)
]

{ #category : 'layout' }
DockStackView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'as yet unclassified' }
DockStackView >> doCloseEditors [
	
	listPresenter items do: [ :each | self closeEditor: each ]
]

{ #category : 'private - actions' }
DockStackView >> doCloseSelectedEditors [
	
	listPresenter selectedItems do: [ :each | 
		self closeEditor: each ]
]

{ #category : 'events' }
DockStackView >> eventEditorActivated: anAnnouncement [
	| currentItem |
	
	currentItem := listPresenter items
		detect: [ :each | each = anAnnouncement value model ]
		ifNone: [ nil ].
		
	currentItem ifNotNil: [
		listPresenter selectedItem ifNotNil: [ listPresenter unselectAll ].
		listPresenter selectItem: currentItem. 
		^ self].

	self updatePresenter.
	listPresenter selectedItem ifNotNil: [ listPresenter unselectAll ].
	listPresenter selectItem: anAnnouncement value model
]

{ #category : 'events' }
DockStackView >> eventEditorClosed: anAnnouncement [
	
	"this just has sense if this is the last one, because all the others will be 
	 processed when autoselect the next editor"
	"listPresenter items size > 1 ifTrue: [ ^ self ]."
	self updatePresenter
]

{ #category : 'events' }
DockStackView >> eventModelChanged: anAnnouncement [
	
	"if name changed, I will need to show the change"
	(anAnnouncement oldEntity isNil 
		or: [ anAnnouncement value fullName = anAnnouncement oldEntity fullName ]) 
		ifTrue: [ ^ self ].
	
	self updatePresenter
]

{ #category : 'initialization' }
DockStackView >> initializePresenters [

	self addStyle: 'dockStack'.

	toolbarPresenter := self instantiate: DockToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #editorStackGeneral).
	
	listPresenter := self newEasyListView
		addStyle: 'stList';
		beMultipleSelection;
		rowPresenterClass: DockStackRow;
		actions: (self actions actionsForAll: #(editorStack editorStackGeneral));
		yourself
]

{ #category : 'initialization' }
DockStackView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Editor Stack'
]

{ #category : 'private - announcing' }
DockStackView >> notifySelectEntity: aCollection [

	aCollection ifEmpty: [ ^ self ].
	super notifySelectEntity: aCollection first
]

{ #category : 'initialization' }
DockStackView >> registerToEvents [

	self announcer 
		when: DockEditorActivated send: #eventEditorActivated: to: self;
		when: DockToolEditorActivated send: #eventEditorActivated: to: self;
		when: DockEditorClosed send: #eventEditorClosed: to: self;
		when: DockModelChanged send: #eventModelChanged: to: self
]

{ #category : 'initialization' }
DockStackView >> updatePresenter [

	self window ifNil: [ ^ self ].

	listPresenter updateItemsKeepingSelection: (self window editors 
		collect: [ :each | each presenter model ]) reversed
]
