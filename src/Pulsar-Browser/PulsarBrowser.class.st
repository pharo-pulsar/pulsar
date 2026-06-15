Class {
	#name : 'PulsarBrowser',
	#superclass : 'PulsarBaseBrowser',
	#instVars : [
		'projectView',
		'outlineView'
	],
	#category : 'Pulsar-Browser-View-Browser',
	#package : 'Pulsar-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing - defaults' }
PulsarBrowser class >> defaultWindowSize [

	^ 1200@950
]

{ #category : 'private - definitions' }
PulsarBrowser class >> defineToolActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #tools with: [ :group | group 
		priority: 10;
		name: 'tools';
		beDisplayedAsGroup;
		addActionWith: [ :action | action
			priority: 100;
			name: 'Playground';
			description: 'Open a new playground in your browser';
			action: [ :aContext | aContext openPlayground ] ];
		addActionWith: [ :action | action 
			priority: 200;
			name: 'Process Browser';
			description: 'Open the Process Browser';
			action: [ :aContext | aContext spawnNewProcessBrowser ] ];
		addActionWith: [ :action | action 
			priority: 910;
			name: 'Recent Changes';
			description: 'Open Recent Changes log';
			action: [ :aContext | aContext spawnRecentChanges ] ];
		addActionWith: [ :action | action
			priority: 920;
			name: 'Repositories';
			description: 'Open git repositories';
			actionState: [ :aContext | aContext hasPresenterClass: PulsarRepositoriesView ];
			action: [ :aContext | aContext openRepositories ] ];
		addActionWith: [ :anAction | anAction
			priority: 930;
			name: 'Flag Console';
			description: 'Open flags console';
			actionState: [ :aContext | aContext hasPresenterClass: PulsarFlagsConsole ];
			action: [ :aContext | aContext openFlagsConsole ] ];
		addActionWith: [ :anAction | anAction
			priority: 940;
			name: 'Critiques Console';
			description: 'Open critiques console';
			actionState: [ :aContext | aContext  hasPresenterClass: PulsarCritiquesConsole ];
			action: [ :aContext | aContext openCritiquesConsole ] ] ]
]

{ #category : 'private' }
PulsarBrowser >> composeTitle [

	^ (projectView isNotNil and: [ projectView openedProjects isNotEmpty ])
		ifTrue: [
			'Pharo({1}): {2}' format: { 
				FileLocator image base.
				', ' join: (projectView openedProjects collect: #name) } ]
		ifFalse: [ 
			'Pharo({1})' format: { FileLocator image base } ]
]

{ #category : 'api - focus' }
PulsarBrowser >> defaultKeyboardFocus [

	^ projectView
]

{ #category : 'private - definitions' }
PulsarBrowser >> defineDevelopmentToolsActionsOn: aBuilder [
	<dockActions>

	"this actions are just possible in linux"
	OSPlatform current isLinux ifFalse: [ ^ self ].
	
	aBuilder addAll: (PulsarMorphicWorldActivator uniqueInstance actions entries)
]

{ #category : 'private - definitions' }
PulsarBrowser >> defineExtraActionsOn: aBuilder [
	<dockActions>
	"nothing here for now, but we override because the playground is 
	 already in the tool list"
]

{ #category : 'actions' }
PulsarBrowser >> doOpenCritiquesConsole: stateBoolean [
	
	self 
		doToggleTool: PulsarCritiquesConsole
		model: (PulsarCritiquesModel on: self model) 
		state: stateBoolean
]

{ #category : 'actions' }
PulsarBrowser >> doOpenEditorStack: stateBoolean [
	
	self 
		doToggleTool: PulsarStackView
		state: stateBoolean
]

{ #category : 'actions' }
PulsarBrowser >> doOpenFileManager: stateBoolean [
	
	self 
		doToggleTool: PulsarDirectoryView
		model: (PulsarDirectoryModel 
			newEnvironment: self model 
			entity: FileLocator imageDirectory) 
		state: stateBoolean
]

{ #category : 'actions' }
PulsarBrowser >> doOpenFlagsConsole: stateBoolean [
	self 
		doToggleTool: PulsarFlagsConsole
		model: (PulsarFlagsModel on: self model) 
		state: stateBoolean
]

{ #category : 'actions' }
PulsarBrowser >> doOpenRepositories: stateBoolean [

	self 
		doToggleTool: PulsarRepositoriesView
		model: (PulsarRepositoriesModel on: self model) 
		state: stateBoolean
]

{ #category : 'private - actions' }
PulsarBrowser >> doToggleTool: aToolClass model: aModel state: aBoolean [ 
	"state would be the current state, toggle the tool"
	| toolView |

	toolView := self findPresenterClass: aToolClass.
	(aBoolean and: [ toolView isNotNil ]) 
		ifTrue: [ 
			toolView withNearWindowLikeDo: #close.
			^ self ].

	toolView ifNil: [ 
		toolView  := self 
			addPresenterClass: aToolClass 
			model: aModel ].
	toolView panelWidget raiseAndTakeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarBrowser >> doToggleTool: aToolClass state: aBoolean [
	
	^ self 
		doToggleTool: aToolClass 
		model: nil 
		state: aBoolean
]

{ #category : 'private' }
PulsarBrowser >> editorStackView [
	"answer the editor stack view if present, nil if not"

	^ self findPresenterClass: PulsarStackView
]

{ #category : 'events' }
PulsarBrowser >> eventManyModelDeactivated: anAnnouncement [
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
PulsarBrowser >> eventTestSuiteEnded: aTestSuiteEnded [
	| message |
	
	self scheduleTask: [ self resendAnnouncement: aTestSuiteEnded ].
	self scheduleTask: [
		message := 'Passed'.
		aTestSuiteEnded testResult hasFailures ifTrue: [ message := 'Has failures' ].
		aTestSuiteEnded testResult hasErrors ifTrue: [ message := 'Has errors' ].
		self inform: ('Test run: <span foreground="{1}">{2}.</span>' format: {
					 (self application colorForTestResultAt: aTestSuiteEnded testResult status).
					 message }) ]
]

{ #category : 'private' }
PulsarBrowser >> informLostChanges: ann [ 

	logger trace: ann.
	self addToast: (SpPanelToast new 
		timeout: 10;
		title: 'Lost Changes Detected.';
		actionLabel: 'Recover';
		action: [ self schedule: [ self spawnRecentChanges ] ];
		yourself)
]

{ #category : 'initialization' }
PulsarBrowser >> initialExtent [

	^ self class lastWindowSize ifNil: [ super initialExtent ]
]

{ #category : 'initialization' }
PulsarBrowser >> initialize [

	"model can be already initialized from the recover snapshot"
	model ifNil: [ model := PvEnvironmentModel onSystem ].
	super initialize
]

{ #category : 'initialization' }
PulsarBrowser >> initializeDefaultWorkspace [

	"I need a better control on these one"
	projectView := self addPresenterClass: PulsarProjectView model: self model newMultiProjectModel.
	outlineView := self addPresenterClass: PulsarClassOutlineView.

	"here, the list of components that are part of the 'sides' but we access 
	 just while interacting."
	self addPresenterClass: PulsarStackView.
	self addPresenterClass: PulsarRepositoriesView model: (PulsarRepositoriesModel on: self model).
	self addPresenterClass: PulsarCritiquesConsole model: (PulsarCritiquesModel on: self model). 	
	self addPresenterClass: PulsarFlagsConsole model: (PulsarFlagsModel on: self model). 	
	self addPresenterClass: PulsarPlayground.
	self 
		addPresenterClass: PulsarDirectoryView 
		model: (PulsarDirectoryModel newEnvironment: self model entity: FileLocator imageDirectory).
	
	"add welcome editor"
	self addPresenterClass: PulsarWelcomeView.
	
	self updateTitle
]

{ #category : 'initialization' }
PulsarBrowser >> initializeStatusbar [

	self statusbar addSuffix: (self newToolbar 
		displayMode: self application toolbarDisplayMode;
		fillWith: (self globalActions actionsFor: #panels))
]

{ #category : 'initialization' }
PulsarBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter
]

{ #category : 'initialization' }
PulsarBrowser >> initializeWorkspace [

	super initializeWorkspace.
	
	"defaults"
	self startWidth: 300.
	self endWidth: 300.
	self topHeight: 250.
	self bottomHeight: 250
]

{ #category : 'actions' }
PulsarBrowser >> openClass: aClass [ 

	self projectView notifyActivateEntity: (PvClassModel 
		newEnvironment: self model environmentModel
		entity: aClass)
]

{ #category : 'actions' }
PulsarBrowser >> openMethod: aMethod [ 

	self projectView notifyActivateEntity: (PvMethodModel 
		newEnvironment: self model environmentModel
		entity: aMethod)
]

{ #category : 'actions' }
PulsarBrowser >> openPlayground [

	self addPresenterClass: PulsarPlayground
]

{ #category : 'actions' }
PulsarBrowser >> openProject: aBaselineClass [ 

	projectView addProject: aBaselineClass
]

{ #category : 'private' }
PulsarBrowser >> outlineView [

	^ outlineView
]

{ #category : 'initialization' }
PulsarBrowser >> postRestoreSnapshot: aSnapshot [
	
	projectView := self presenters
		detect: [ :each | each presenter class = PulsarProjectView ]
		ifFound: [ :each | each presenter ]
		ifNone: [ self addPresenterClass: PulsarProjectView model: self model newMultiProjectModel ].
		
	outlineView := self presenters
		detect: [ :each | each presenter class = PulsarClassOutlineView ]
		ifFound: [ :each | each presenter ]
		ifNone: [ self addPresenterClass: PulsarClassOutlineView ].
	
	self updateTitle
]

{ #category : 'private' }
PulsarBrowser >> projectView [

	^ projectView
]

{ #category : 'initialization' }
PulsarBrowser >> registerToEvents [

	super registerToEvents.
	self registerToTestCaseEvents.
	self announcer 
		when: PulsarLostChangesAnnouncement 
			send: #informLostChanges:
			to: self
]

{ #category : 'initialization' }
PulsarBrowser >> registerToTestCaseEvents [
	
	self announcer
		when: TestSuiteEnded send: #eventTestSuiteEnded: to: self;
		when: TestCaseEnded, TestCaseStarted 
			send: #resendAnnouncement: 
			to: self
]

{ #category : 'private' }
PulsarBrowser >> repositoriestView [
	"answer the repositories view if present, nil if not"

	^ self findPresenterClass: PulsarRepositoriesView		
]

{ #category : 'accessing - snapshot' }
PulsarBrowser >> snapshot [

	^ PulsarBrowserSnapshot on: self
]

{ #category : 'actions' }
PulsarBrowser >> spawnNewBrowser [

	(PulsarBrowser newApplication: self application) open
]

{ #category : 'actions' }
PulsarBrowser >> spawnNewProcessBrowser [
	
	(StProcessBrowser newApplication: self application) open
]

{ #category : 'actions' }
PulsarBrowser >> spawnRecentChanges [

	(PulsarChangesBrowser newApplication: self application) open
]

{ #category : 'initialization' }
PulsarBrowser >> updateTitle [
	| newTitle |

	newTitle := self composeTitle.
	logger trace: newTitle.
	self title: newTitle
]

{ #category : 'private' }
PulsarBrowser >> windowWillClose [

	^ self application windowWillClose: self
]
