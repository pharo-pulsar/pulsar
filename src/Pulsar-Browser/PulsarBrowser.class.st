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
PulsarBrowser class >> defineImageActionsOn: aBuilder [
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

{ #category : 'private - definitions' }
PulsarBrowser class >> defineSpotterActionsOn: aBuilder [
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

{ #category : 'private - definitions' }
PulsarBrowser class >> defineToolActionsOn: aBuilder [
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
			action: [ :aContext | aContext openFlagsConsole ] ];
		addActionWith: [ :anAction | anAction
			priority: 940;
			name: 'Open Critiques Console';
			description: 'Open critiques console';
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
PulsarBrowser >> defineExtraActionsOn: aBuilder [
	<dockActions>
	"nothing here for now, but we override because the playground is 
	 already in the tool list"
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
	self addPresenterClass: PulsarCritiquesConsole model: (PulsarCritiquesModel on: self model). 	
	self addPresenterClass: PulsarFlagsConsole model: (PulsarFlagsModel on: self model). 	
	self addPresenterClass: PulsarPlayground.
	
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
PulsarBrowser >> openCritiquesConsole [
	| critiquesConsole |
	
	critiquesConsole := self presenters 
		detect: [ :each | each presenter isKindOf: PulsarCritiquesConsole ]
		ifNone: [ 
			(self 
				addPresenterClass: PulsarCritiquesConsole 
				model: (PulsarCritiquesModel on: self model))
			panelWindow ].

	critiquesConsole raiseAndTakeKeyboardFocus
]

{ #category : 'actions' }
PulsarBrowser >> openFlagsConsole [
	| flagsConsole |
	
	flagsConsole := self presenters 
		detect: [ :each | each presenter isKindOf: PulsarFlagsConsole ]
		ifNone: [ 
			(self 
				addPresenterClass: PulsarFlagsConsole 
				model: (PulsarFlagsModel on: self model))
			panelWindow ].

	flagsConsole raiseAndTakeKeyboardFocus
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

{ #category : 'actions' }
PulsarBrowser >> openRepositories [
	| repositoryView |

	repositoryView := self findPresenterClass: PulsarRepositoriesView.
	repositoryView ifNil: [ 
		repositoryView := self 
			addPresenterClass: PulsarRepositoriesView 
			model: (PulsarRepositoriesModel 
				newEnvironment: self model
				parent: self model
				entity: nil) ].
	repositoryView takeKeyboardFocus
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

{ #category : 'actions' }
PulsarBrowser >> saveImage [

	[ Smalltalk snapshot: true andQuit: false ] fork.
	self inform: 'Image saved'
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
