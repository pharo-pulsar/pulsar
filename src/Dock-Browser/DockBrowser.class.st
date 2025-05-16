Class {
	#name : 'DockBrowser',
	#superclass : 'DockBaseBrowser',
	#instVars : [
		'projectView',
		'outlineView'
	],
	#classVars : [
		'LastWindowSize'
	],
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing - actions' }
DockBrowser class >> defineImageActionGroup: actionGroup [
	<perspectiveActionGroup: #image>
	
	actionGroup 
		name: 'Image';
		priority: 1000;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockBrowser class >> defineImageActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #image with: { 
		"open default tool"
		$s shift mod1 -> DockImageSaveCommand new.
		"Character mod1 mod3 -> PvShowSpotterForCommandsAction new" }
]

{ #category : 'accessing - actions' }
DockBrowser class >> defineSpotterActionGroup: actionGroup [
	<perspectiveActionGroup: #spotter>
	
	actionGroup 
		name: 'Spotter';
		priority: 900;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockBrowser class >> defineSpotterActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #spotter with: { 
		"open default tool"
		Character cr shift -> DockShowSpotterForEnvironmentCommand new.
		Character cr shift mod1 -> DockShowSpotterForWindowsCommand new.
		"Character mod1 mod3 -> PvShowSpotterForCommandsAction new" }
]

{ #category : 'accessing - actions' }
DockBrowser class >> defineToolActionGroup: actionGroup [
	<perspectiveActionGroup: #tools>
	
	actionGroup 
		name: 'Tools';
		priority: 10;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockBrowser class >> defineToolActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #tools with: { 
		DockOpenPlaygroundCommand new.
		DockOpenBrowserCommand new.
	}
]

{ #category : 'private' }
DockBrowser >> composeTitle [

	^ (projectView isNotNil and: [ projectView openedProjects isNotEmpty ])
		ifTrue: [
			'Pharo({1}): {2}' format: { 
				FileLocator image base.
				', ' join: (projectView openedProjects collect: #name) } ]
		ifFalse: [ 
			'Pharo({1})' format: { FileLocator image base } ]
]

{ #category : 'api - focus' }
DockBrowser >> defaultKeyboardFocus [

	^ projectView
]

{ #category : 'events' }
DockBrowser >> eventManyModelDeactivated: anAnnouncement [
	| editors |

	editors := anAnnouncement value copy.
	"I suspend announcements for most of them"
	self announcer suspendAllWhile: [
		editors allButLast 
			do: [ :each | self maybeUndockView: each ] ].
	"except the last one, to ensure system update is triggered"
	self maybeUndockView: editors last
]

{ #category : 'events' }
DockBrowser >> eventModelActivated: anAnnouncement [
	
	
	self maybeDockView: anAnnouncement value
]

{ #category : 'events' }
DockBrowser >> eventModelDeactivated: anAnnouncement [
	
	self maybeUndockView: anAnnouncement value
]

{ #category : 'initialization' }
DockBrowser >> initialExtent [

	^ LastWindowSize ifNil: [ super initialExtent ]
]

{ #category : 'initialization' }
DockBrowser >> initialize [

	self setModelBeforeInitialization: PvEnvironmentModel onSystem.
	super initialize
]

{ #category : 'initialization' }
DockBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		initialExtent: (LastWindowSize ifNil: [ 1000@800 ]);
		whenResizingDo: [ :ann | LastWindowSize := ann newSize ];
		whenWillCloseDo: [ :ann | 
			self windowWillClose 
				ifFalse: [ ann denyClose ] ];
		whenClosedDo: [ self windowClosed ]
]

{ #category : 'initialization' }
DockBrowser >> initializeWorkspace [

	"defaults"
	self startWidth: 280"self initialExtent x * 25 percent".
	self endWidth: 280"self initialExtent x * 25 percent".
	self bottomHeight: 180"self initialExtent y * 20 percent"
]

{ #category : 'initialization' }
DockBrowser >> loadDefaultWorkspace [

	"I need a better control on these one"
	projectView := self addPresenterClass: DockProjectView model: self model newMultiProjectModel.
	outlineView := self addPresenterClass: DockClassOutlineView.

	"here, the list of components that are part of the 'sides' but we access 
	 just while interacting."	
	{ DockStackView. DockPlayground. "DockTranscript" } 
		do: [ :eachClass | self addPresenterClass: eachClass ]
]

{ #category : 'private' }
DockBrowser >> maybeDockView: aViewModel [
	"if the entity has an editor associated:
	 	if the entity is not already there, open it.
	 	if the entity is already opened, 
			if it can have multiple views: open it.
			if it is single view: select it
	 otherwise ignore it"
	| editorPresenter |

	aViewModel hasDockEditor ifFalse: [ ^ self ].

	(self findEditorContaining: aViewModel) ifNotNil: [ :panelPresenter | 
		panelPresenter raiseAndTakeKeyboardFocus.
		^ self ].

	editorPresenter := self 
		instantiate: aViewModel dockEditorClass
		on: aViewModel. 
	self 
		addPresenter: editorPresenter 
		at: editorPresenter dockPosition
]

{ #category : 'private' }
DockBrowser >> maybeUndockView: aViewModel [

	aViewModel hasDockEditor ifFalse: [ ^ self ].
	(self findEditorContaining: aViewModel) 
		ifNotNil: [ :panelPresenter | panelPresenter close ]
]

{ #category : 'showing' }
DockBrowser >> open [

	self presenters ifEmpty: [ 
		self loadDefaultWorkspace ].
	super open
]

{ #category : 'actions' }
DockBrowser >> openClass: aClass [ 

	self projectView notifyActivateEntity: (PvClassModel 
		newEnvironment: self model environmentModel
		entity: aClass)
]

{ #category : 'actions' }
DockBrowser >> openPlayground [

	self addPresenterClass: DockPlayground
]

{ #category : 'actions' }
DockBrowser >> openProject: aBaselineClass [ 

	projectView addProject: aBaselineClass
]

{ #category : 'private' }
DockBrowser >> outlineView [

	^ outlineView
]

{ #category : 'initialization' }
DockBrowser >> postRestoreSnapshot: aSnapshot [
	
	projectView := self presenters
		detect: [ :each | each presenter class = DockProjectView ]
		ifFound: [ :each | each presenter ]
		ifNone: [ self addPresenterClass: DockProjectView model: self model newMultiProjectModel ].
		
	outlineView := self presenters
		detect: [ :each | each presenter class = DockClassOutlineView ]
		ifFound: [ :each | each presenter ]
		ifNone: [ self addPresenterClass: DockClassOutlineView ].

	self updateTitle
]

{ #category : 'private' }
DockBrowser >> projectView [

	^ projectView
]

{ #category : 'accessing - snapshot' }
DockBrowser >> snapshot [

	^ DockBrowserSnapshot on: self
]

{ #category : 'actions' }
DockBrowser >> spawnNewBrowser [

	(DockBrowser newApplication: self application) open
]

{ #category : 'initialization' }
DockBrowser >> updateTitle [
	| newTitle |

	newTitle := self composeTitle.
	logger trace: newTitle.
	self title: newTitle
]

{ #category : 'event handling' }
DockBrowser >> windowWillClose [
	| ann canClose |

	ann := SpWindowWillClose new.
	canClose := self editors reversed allSatisfy: [ :each | 
		ann window: each.
		each announce: ann.
		ann canClose ].
		
	self application windowWillClose: self.
		
	^ canClose
]
