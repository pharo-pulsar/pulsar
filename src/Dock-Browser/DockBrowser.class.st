Class {
	#name : 'DockBrowser',
	#superclass : 'DockBaseBrowser',
	#instVars : [
		'projectView',
		'outlineView'
	],
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing - actions' }
DockBrowser class >> defineImageActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #image with: [ :group | group 
		name: 'Image';
		priority: 2000;
		beDisplayedAsGroup;
		addActionWith: [ :action | action
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
	aBuilder addGroup: #spotter with: [ :group | group 
		name: 'Spotter';
		priority: 900;
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Spotter';
			description: 'Show spotter for Environment';
			shortcutKey: KeyboardKey enter shift;
			action: [ :aContext | aContext doShowSpotterForEnvironment ] ]";
		addActionWith: [ :action | action 
			name: 'Spotter for Windows';
			description: 'Show spotter for Windows';
			shortcutKey: KeyboardKey enter shift mod1;
			action: [ :aContext | aContext doShowSpotterForWindows ] ];		
		addActionWith: [ :action | action 
			name: 'Spotter for Commands';
			description: 'Show spotter for Commands';
			shortcutKey: KeyboardKey enter shift;
			action: [ :aContext | aContext doShowSpotterForCommands ] ]" 
		]
]

{ #category : 'accessing - actions' }
DockBrowser class >> defineToolActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #tools with: [ :group | group 
		priority: 10;
		name: 'tools';
		beDisplayedAsGroup;
		addActionWith: [ :action | action
			priority: 100;
			name: 'New Playground';
			description: 'Open a new playground in your browser';
			action: [ :aContext | aContext openPlayground ] ];
		addActionWith: [ :action | action 
			priority: 200;
			name: 'Open Process Browser';
			description: 'Open the Process Browser';
			action: [ :aContext | aContext spawnNewProcessBrowser ] ];
		addActionWith: [ :action | action 
			priority: 910;
			name: 'Open Recent Changes';
			description: 'Open Recent Changes log';
			action: [ :aContext | aContext spawnRecentChanges ] ];
		addActionWith: [ :action | action
			priority: 920;
			name: 'Open Repositories';
			description: 'Open git repositories';
			action: [ :aContext | aContext openRepositories ] ];
		addActionWith: [ :anAction | anAction
			priority: 930;
			name: 'Open Flag Console';
			description: 'Open flags console';
			action: [ :aContext | aContext openFlagsConsole ] ] ]
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
	
	self 
		maybeDockView: anAnnouncement value
		withActivation: anAnnouncement
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

	^ self class lastWindowSize ifNil: [ super initialExtent ]
]

{ #category : 'initialization' }
DockBrowser >> initialize [
	"model can be already initialized from the recover snapshot"
	model ifNil: [
		"but if not, we need an initial model"
		model := PvEnvironmentModel onSystem ].
	super initialize
]

{ #category : 'initialization' }
DockBrowser >> initializeDefaultWorkspace [

	"I need a better control on these one"
	projectView := self addPresenterClass: DockProjectView model: self model newMultiProjectModel.
	outlineView := self addPresenterClass: DockClassOutlineView.

	"here, the list of components that are part of the 'sides' but we access 
	 just while interacting."
	self addPresenterClass: DockStackView.
	self addPresenterClass: DockFlagsConsole model: (DockFlagsModel on: self model). 	
	self addPresenterClass: DockPlayground.
	
	self updateTitle
]

{ #category : 'initialization' }
DockBrowser >> initializeStatusbar [

	self statusbar addSuffix: (self newToolbar 
		displayMode: self application toolbarDisplayMode;
		fillWith: (self globalActions actionsFor: #panels))
]

{ #category : 'initialization' }
DockBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter
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

{ #category : 'private' }
DockBrowser >> maybeDockView: aViewModel withActivation: anActivation [
	"if the entity has an editor associated:
	 	if the entity is not already there, open it.
	 	if the entity is already opened, 
			if it can have multiple views: open it.
			if it is single view: select it
	 otherwise ignore it"
	| editorPresenter |

	aViewModel hasDockEditor ifFalse: [ ^ self ].

	(self findEditorContaining: aViewModel) 
		ifNotNil: [ :panelPresenter | 
			panelPresenter raiseAndTakeKeyboardFocus.
			editorPresenter := panelPresenter presenter ]
		ifNil: [
			editorPresenter := self 
				instantiate: aViewModel dockEditorClass 
				on: aViewModel. 
			self 
				addPresenter: editorPresenter 
				at: editorPresenter dockPosition ].
			
	editorPresenter activateWith: anActivation
]

{ #category : 'private' }
DockBrowser >> maybeUndockView: aViewModel [

	aViewModel hasDockEditor ifFalse: [ ^ self ].

	(self findEditorContaining: aViewModel) 
		ifNotNil: [ :panelPresenter | panelPresenter close ]
]

{ #category : 'actions' }
DockBrowser >> openClass: aClass [ 

	self projectView notifyActivateEntity: (PvClassModel 
		newEnvironment: self model environmentModel
		entity: aClass)
]

{ #category : 'actions' }
DockBrowser >> openFlagsConsole [
	| flagsConsole |
	
	flagsConsole := self presenters 
		detect: [ :each | each presenter isKindOf: DockFlagsConsole ]
		ifNone: [ 
			(self 
				addPresenterClass: DockFlagsConsole 
				model: (DockFlagsModel on: self model))
			panelWindow ].

	flagsConsole raiseAndTakeKeyboardFocus
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
	| repositoryView |
	repositoryView := self findPresenterClass: DockRepositoriesView.
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

{ #category : 'accessing - snapshot' }
DockBrowser >> snapshot [

	^ DockBrowserSnapshot on: self
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

{ #category : 'private' }
DockBrowser >> windowWillClose [

	^ self application windowWillClose: self
]
