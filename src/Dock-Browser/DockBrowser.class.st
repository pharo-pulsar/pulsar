Class {
	#name : 'DockBrowser',
	#superclass : 'DockBaseBrowser',
	#instVars : [
		'projectView',
		'outlineView',
		'repositoryView'
	],
	#classVars : [
		'LastWindowSize'
	],
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing - actions' }
DockBrowser class >> defineImageActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #image with: [ :aGroup | aGroup 
		name: 'Image';
		priority: 2000;
		beDisplayedAsGroup;
		addActionWith: [ :anItem | anItem
			name: 'Save';
			description: 'Save image';
			shortcutKey: $s shift mod1;
			action: [ :aContext | aContext saveImage ] ] ]
]

{ #category : 'accessing - actions' }
DockBrowser class >> defineSpotterActionsOn: aBuilder [
	<dockActions>

	self flag: #TODO. "Move this to superclass, but for that I first need to define 
	what a spotter for a debugger will be, for example (and other possible root-level 
	browsers)" 
	aBuilder addGroup: #spotter with: [ :aGroup | aGroup 
		name: 'Spotter';
		priority: 900;
		beDisplayedAsGroup;
		addActionWith: [ :anItem | anItem 
			name: 'Spotter';
			description: 'Show spotter for Environment';
			shortcutKey: KeyboardKey enter shift;
			action: [ :aContext | aContext doShowSpotterForEnvironment ] ]";
		addActionWith: [ :anItem | anItem 
			name: 'Spotter for Windows';
			description: 'Show spotter for Windows';
			shortcutKey: KeyboardKey enter shift mod1;
			action: [ :aContext | aContext doShowSpotterForWindows ] ];		
		addActionWith: [ :anItem | anItem 
			name: 'Spotter for Commands';
			description: 'Show spotter for Commands';
			shortcutKey: KeyboardKey enter shift;
			action: [ :aContext | aContext doShowSpotterForCommands ] ]" 
		]
]

{ #category : 'accessing - actions' }
DockBrowser class >> defineToolActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #tools with: [ :aGroup | aGroup 
		priority: 10;
		name: 'tools';
		beDisplayedAsGroup;
		addActionWith: [ :anAction | anAction
			priority: 100;
			name: 'New Playground';
			description: 'Open a new playground in your browser';
			action: [ :aContext | aContext openPlayground ] ];
		addActionWith: [ :anAction | anAction 
			priority: 200;
			name: 'Open Process Browser';
			description: 'Open the Process Browser';
			action: [ :aContext | aContext spawnNewProcessBrowser ] ];
		addActionWith: [ :anAction | anAction 
			priority: 910;
			name: 'Open Recent Changes';
			description: 'Open Recent Changes log';
			action: [ :aContext | aContext spawnRecentChanges ] ];
		addActionWith: [ :anAction | anAction
			priority: 920;
			name: 'Open Repositories';
			description: 'Open git repositories';
			action: [ :aContext | aContext openRepositories ] ] ]
]

{ #category : 'private' }
DockBrowser >> addTool: ann [ 

	self addPresenterClass: ann toolClass
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
	logger trace: editors.
	"I suspend announcements for most of them"
	self application defer: [
		self notificationCenter suspendAllWhile: [
			editors allButLast 
				do: [ :each | self maybeUndockView: each ] ].
		"except the last one, to ensure system update is triggered"
		self maybeUndockView: editors last ]
]

{ #category : 'events' }
DockBrowser >> eventModelActivated: anAnnouncement [
	
	self maybeDockView: anAnnouncement value
]

{ #category : 'events' }
DockBrowser >> eventModelDeactivated: anAnnouncement [
	
	self maybeUndockView: anAnnouncement value
]

{ #category : 'events' }
DockBrowser >> eventTestSuiteEnded: aTestSuiteEnded [
	| message |

	self schedule: [
		self resendAnnouncement: aTestSuiteEnded ].

	self schedule: [
		message := 'Passed'.
		aTestSuiteEnded testResult hasFailures ifTrue: [ message := 'Has failures' ].
		aTestSuiteEnded testResult hasErrors ifTrue: [ message := 'Has errors' ].
		self inform: ('Test run: <span foreground="{1}">{2}.</span>' format: {
			self application colorForTestResultAt: aTestSuiteEnded testResult status.
			message }) ]
]

{ #category : 'private' }
DockBrowser >> informLostChanges: ann [ 

	logger trace: ann.
	self addToast: (SpPanelToast new 
		timeout: 10;
		title: 'Lost Changes Detected.';
		actionLabel: 'Recover';
		action: [ self schedule: [ self spawnRecentChanges ] ];
		yourself)
]

{ #category : 'initialization' }
DockBrowser >> initialExtent [

	^ LastWindowSize ifNil: [ super initialExtent ]
]

{ #category : 'initialization' }
DockBrowser >> initialize [

	self setModelBeforeInitialization: PvEnvironmentModel onSystem.
	super initialize.
	self registerToSystemEvents
]

{ #category : 'initialization' }
DockBrowser >> initializeStatusbar [

	self statusbar addSuffix: (self newToolbar 
		displayMode: self application toolbarDisplayMode;
		fillWith: (self globalActions actionsFor: #panels))
]

{ #category : 'initialization' }
DockBrowser >> initializeWindow: aWindowPresenter [
	self flag: #TODO. "In fact, there is no reason why this cannot be 
	in the superclass, available to any dockbrowser window"
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
	super initializeWorkspace.
	
	"defaults"
	self startWidth: 280"self initialExtent x * 25 percent".
	self endWidth: 280"self initialExtent x * 25 percent".
	self topHeight: 180"self initialExtent y * 20 percent".
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
DockBrowser >> openMethod: aMethod [ 

	self projectView notifyActivateEntity: (PvMethodModel 
		newEnvironment: self model environmentModel
		entity: aMethod)
]

{ #category : 'actions' }
DockBrowser >> openPlayground [

	self addPresenterClass: DockPlayground
]

{ #category : 'actions' }
DockBrowser >> openProject: aBaselineClass [ 

	projectView addProject: aBaselineClass
]

{ #category : 'actions' }
DockBrowser >> openRepositories [

	repositoryView ifNil: [ 
		repositoryView := self 
			addPresenterClass: DockRepositoriesView 
			model: (DockRepositoriesModel 
				newEnvironment: self model
				parent: self model
				entity: nil) ].
	repositoryView takeKeyboardFocus
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
	
	repositoryView := self presenters
		detect: [ :each | each presenter class = DockRepositoriesView ]
		ifFound: [ :each | each presenter ]
		ifNone: [ nil ].

	self updateTitle
]

{ #category : 'private' }
DockBrowser >> projectView [

	^ projectView
]

{ #category : 'initialization' }
DockBrowser >> registerToEvents [

	super registerToEvents.
	self registerToTestCaseEvents.
	self announcer 
		when: DockLostChangesAnnouncement send: #informLostChanges: to: self;
		when: DockRequestToolAnnouncement send: #addTool: to: self
]

{ #category : 'initialization' }
DockBrowser >> registerToSystemEvents [

	self announcer 
		when: SystemAnnouncement 
		send: #resendAnnouncement: 
		to: self
]

{ #category : 'initialization' }
DockBrowser >> registerToTestCaseEvents [
	
	self announcer
		when: TestSuiteEnded send: #eventTestSuiteEnded: to: self;
		when: TestCaseEnded, TestCaseStarted 
			send: #resendAnnouncement: 
			to: self
]

{ #category : 'private' }
DockBrowser >> repositoryView [

	^ repositoryView
]

{ #category : 'actions' }
DockBrowser >> saveImage [

	[ Smalltalk snapshot: true andQuit: false ] fork.
	self inform: 'Image saved'
]

{ #category : 'actions' }
DockBrowser >> spawnNewBrowser [

	(DockBrowser newApplication: self application) open
]

{ #category : 'actions' }
DockBrowser >> spawnNewProcessBrowser [
	
	(StProcessBrowser newApplication: self application) open
]

{ #category : 'actions' }
DockBrowser >> spawnRecentChanges [

	(DockChangesBrowser newApplication: self application) open
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
