"
A base for all dock browsers (there should not be a lot, but more than one)
"
Class {
	#name : 'PulsarBaseBrowser',
	#superclass : 'SpPanelWindowPresenter',
	#traits : 'SpTModel + PulsarTSnapshot + PulsarTGlobalActionContainer + PulsarTTaskScheduler + PulsarTJobHandler',
	#classTraits : 'SpTModel classTrait + PulsarTSnapshot classTrait + PulsarTGlobalActionContainer classTrait + PulsarTTaskScheduler classTrait + PulsarTJobHandler classTrait',
	#instVars : [
		'actions',
		'mutex'
	],
	#classInstVars : [
		'lastWindowSize',
		'browserPanelLayouts'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
PulsarBaseBrowser class >> browserPanelLayouts [

	^ browserPanelLayouts ifNil: [ 
		browserPanelLayouts := OrderedCollection with: PulsarBrowserPanelLayout new ]
]

{ #category : 'private - panel layout' }
PulsarBaseBrowser class >> defaultPanelLayout [

	^ self browserPanelLayouts first
]

{ #category : 'accessing - defaults' }
PulsarBaseBrowser class >> defaultWindowSize [

	^ 1100@950
]

{ #category : 'private - definitions' }
PulsarBaseBrowser class >> defineImageActionsOn: aBuilder [
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
PulsarBaseBrowser class >> definePanelActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #panels with: [ :group | group 
		priority: 1000;
		name: 'Panels';
		beDisplayedAsSubMenu.
		 
		{  
			{ 'bottom'.	SpPanelArea bottom }.
			{ 'left'.	SpPanelArea start }.
			{ 'right'. 	SpPanelArea end }.
			{ 'top'. 	SpPanelArea top }.
		} withIndexDo: [ :each :index |
			group addActionWith: [ :action | action 
				priority: index; 
				name: 'Toggle panel ', each first;
				description: 'Show/hide the ', each first, ' panel';
				iconName: 'panel-', each first;
				action: [ :aContext | aContext togglePanelArea: each second  ] ]
			 ] ].
]

{ #category : 'private - definitions' }
PulsarBaseBrowser class >> defineSpotterActionsOn: aBuilder [
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

{ #category : 'private - accessing' }
PulsarBaseBrowser class >> lastWindowSize [

	^ lastWindowSize ifNil: [ self defaultWindowSize ]
]

{ #category : 'private - accessing' }
PulsarBaseBrowser class >> lastWindowSize: aPoint [

	lastWindowSize := aPoint
]

{ #category : 'instance creation' }
PulsarBaseBrowser class >> newApplication: anApplication model: aModel snapshot: aSnapshot [

	^ self basicNew
		application: anApplication;
		setModelBeforeInitialization: aModel;
		initializeSnapshot: aSnapshot;
		yourself
]

{ #category : 'private - panel layout' }
PulsarBaseBrowser class >> resetAllPanelLayouts [
	<script>

	self withAllSubclassesDo: #resetPanelLayouts
]

{ #category : 'private - panel layout' }
PulsarBaseBrowser class >> resetPanelLayouts [

	"we reset just the default, so if we saved some, we still 
	 have them"
	self defaultPanelLayout reset
]

{ #category : 'private - panel layout' }
PulsarBaseBrowser class >> savePanelPosition: aSpPanelPosition forViewClass: aClass [

	self defaultPanelLayout savePanelPosition: aSpPanelPosition forViewClass: aClass
]

{ #category : 'private - panel layout' }
PulsarBaseBrowser class >> savedPositionForViewClass: aClass ifAbsent: absentBlock [

	^ self defaultPanelLayout savedPositionForViewClass: aClass ifAbsent: absentBlock
]

{ #category : 'private' }
PulsarBaseBrowser >> addGlobalActionsTo: aWindowPresenter [

	self globalActions 
		ifNotNil: [ :aGroup | aWindowPresenter actions: aGroup ]
]

{ #category : 'view' }
PulsarBaseBrowser >> addPresenterClass: aClass [
	| view position |
	
	view := self instantiate: aClass.
	position := self class 
		savedPositionForViewClass: aClass 
		ifAbsent: [ view panelPosition ].
	self addPresenter: view at: position.

	^ view
]

{ #category : 'view' }
PulsarBaseBrowser >> addPresenterClass: aClass model: aModel [
	| view position |
	
	view := self instantiate: aClass on: aModel.
	position := self class 
		savedPositionForViewClass: aClass 
		ifAbsent: [ view panelPosition ].
	self addPresenter: view at: position.

	^ view
]

{ #category : 'accessing' }
PulsarBaseBrowser >> addPresenterClass: aClass position: aPulsarPosition [
	| view |

	view := self instantiate: aClass.
	self addPresenter: view at: aPulsarPosition.
	
	^ view
]

{ #category : 'private' }
PulsarBaseBrowser >> addStatusbarPresenter: aPresenter [
	"As the job will require to add a spinner, we need to implement this"

	"override the trait. Yes, I know I can do it with semantics, but well..."
	super addStatusbarPresenter: aPresenter
]

{ #category : 'private' }
PulsarBaseBrowser >> addTool: ann [

	ann isUnique ifTrue: [
		(self findPresenterClass: ann toolClass) ifNotNil: [ :aPresenter |
			aPresenter withPanelWidgetDo: [ :aPanelWidget | 
				aPanelWidget raiseAndTakeKeyboardFocus ].
			^ self ] ].

	self addPresenterClass: ann toolClass model: ann model
]

{ #category : 'private' }
PulsarBaseBrowser >> addUniquePresenterClass: aPresenterClass [
	
self 
		addUniquePresenterClass: aPresenterClass 
		model: nil
]

{ #category : 'private' }
PulsarBaseBrowser >> addUniquePresenterClass: aPresenterClass model: anObject [

	(self findPresenterClass: aPresenterClass) ifNotNil: [ :aPresenter |
		aPresenter withPanelWidgetDo: [ :aPanelWidget | 
			aPanelWidget raiseAndTakeKeyboardFocus ].
		^ self ].

	self addPresenterClass: aPresenterClass model: anObject
]

{ #category : 'private' }
PulsarBaseBrowser >> addWindow: aWindow [

	self mutex critical: [

		aWindow presenter registerToBrowser: self.

		super addWindow: aWindow.
	
		self flag: #TODO. "This could be better refactored by sending a 
		message (an announcement?) to the panels?"
		aWindow presenter isEditor ifFalse: [
			aWindow whenPanelPositionChangedDo: [ :newPosition |
				"going like this because we can change the window (if transferred)"
				aWindow window class 
					savePanelPosition: newPosition 
					forViewClass: aWindow presenter class  ] ].
		
		aWindow raiseAndTakeKeyboardFocus ]
]

{ #category : 'private' }
PulsarBaseBrowser >> cleanUpSchedulers [
	
	announcer ifNotNil: #purgeTaskWorker.
	self purgeTaskScheduler

]

{ #category : 'private - definitions' }
PulsarBaseBrowser >> defineExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #extra with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Payground';
			description: 'Open a new playground';
			action: [ self doNewPlayground ] ] ]
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> doNewPlayground [

	self notificationCenter announce: (PulsarRequestNewPlayground new	
		model: (PulsarPlaygroundModel on: self model environmentModel);
		yourself)
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> doOpenClassOutlineView [
	| outlineView |

	outlineView := self ensureClassOutlineOverview.
	outlineView takeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> doOpenEditorStackView [
	| stackView |
	
	stackView := self ensureEditorStack.
	stackView takeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> doShowSpotterForCommands [

	self showSpotterOn: #commands
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> doShowSpotterForEnvironment [

	self showSpotterOn: #environment
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> doShowSpotterForWindows [

	self showSpotterOn: #windows
]

{ #category : 'accessing' }
PulsarBaseBrowser >> editors [
	"from my list of presenters, answer those who are containing an editor.
	 Notice that the answer will be a list os SpPanelWidgetPresenter, containing 
	 the editor presenter, no the presenter itself."


	^ self mutex critical: [ 
		super presenters select: [ :each | each panelArea = SpPanelArea center ] ]
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> ensureClassOutlineOverview [

	^ (self findPresenterClass: PulsarClassOutlineView)
		ifNil: [ self addPresenterClass: PulsarClassOutlineView ]
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> ensureEditorStack [

	^ (self findPresenterClass: PulsarStackView)
		ifNil: [ self addPresenterClass: PulsarStackView ]
]

{ #category : 'events' }
PulsarBaseBrowser >> eventJobEnd: ann [

	self jobEnd
]

{ #category : 'events' }
PulsarBaseBrowser >> eventJobStart: ann [

	self jobStart
]

{ #category : 'events' }
PulsarBaseBrowser >> eventManyModelDeactivated: anAnnouncement [
]

{ #category : 'events' }
PulsarBaseBrowser >> eventModelActivated: anAnnouncement [
	
	self 
		maybeDockView: anAnnouncement value
		withActivation: anAnnouncement
]

{ #category : 'events' }
PulsarBaseBrowser >> eventModelDeactivated: anAnnouncement [
	
	self maybeUndockView: anAnnouncement value
]

{ #category : 'accessing' }
PulsarBaseBrowser >> findAllPresentersClass: aClass [
	"answer sll presenters matching the class."
	
	^ self presenter
		select: [ :each | each presenter class = aClass ]
		thenCollect: [ :each | each presenters ]
]

{ #category : 'private' }
PulsarBaseBrowser >> findEditorContaining: aViewModel [

	^ self editors 
		detect: [ :each | each presenter model = aViewModel ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
PulsarBaseBrowser >> findPresenterClass: aClass [
	"answer the first presenter matching the class.
	 since the browser can have many presenters of the same class, this is useful 
	 just in certain cases"
	
	^ self presenters
		detect: [ :each | each presenter class = aClass ]
		ifFound: [ :each | each presenter ]
		ifNone: [ nil ]
]

{ #category : 'testing' }
PulsarBaseBrowser >> hasPresenterClass: aClass [

	^ (self findPresenterClass: aClass) isNotNil
]

{ #category : 'simple dialog helpers' }
PulsarBaseBrowser >> inform: aString [

	logger trace: aString message: 'inform'.
	self addToast: (SpPanelToast new 
		title: aString;
		yourself)
]

{ #category : 'initialization' }
PulsarBaseBrowser >> initialize [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents.
	self initializeDefaultWorkspace
]

{ #category : 'initialization' }
PulsarBaseBrowser >> initializeDefaultWorkspace [
	"override this to add things when the browser do not come from a snapshot (not recovening)"
	
]

{ #category : 'private - initialization' }
PulsarBaseBrowser >> initializePrivateAnnouncer [

  announcer := PulsarTaskAnnouncer new
]

{ #category : 'initialization' }
PulsarBaseBrowser >> initializeSnapshot: aSnapshot [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents
]

{ #category : 'initialization' }
PulsarBaseBrowser >> initializeStatusbar [

	self statusbar addSuffix: (self newToolbar 
		displayMode: self application toolbarDisplayMode;
		fillWith: (self globalActions actionsFor: #panels))
]

{ #category : 'initialization' }
PulsarBaseBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	self addGlobalActionsTo: self.
	
	aWindowPresenter
		initialExtent: self class lastWindowSize;
		whenResizingDo: [ :ann | self class lastWindowSize: ann newSize ];
		whenWillCloseDo: [ :ann | 
			self windowWillClose 
				ifFalse: [ ann denyClose ] ];
		whenClosedDo: [ self windowClosed ]
]

{ #category : 'initialization' }
PulsarBaseBrowser >> initializeWorkspace [
	"IMPORTANT: browser initialize workspace will do just what it has always initialized 
	 **and that is not restored through a snapshot**.
	 To create the initial workspace (created without a snapshot), please override 
	 `initializeDefaultWorkspace` instead this."	
	
	self initializeStatusbar

]

{ #category : 'private' }
PulsarBaseBrowser >> maybeDockView: aViewModel withActivation: anActivation [
	"if the entity has an editor associated:
	 	if the entity is not already there, open it.
	 	if the entity is already opened, 
			if it can have multiple views: open it.
			if it is single view: select it
	 otherwise ignore it"
	| editorPresenter |

	aViewModel hasPulsarEditor ifFalse: [ ^ self ].

	(self findEditorContaining: aViewModel) 
		ifNotNil: [ :panelPresenter | 
			panelPresenter raiseAndTakeKeyboardFocus.
			editorPresenter := panelPresenter presenter ]
		ifNil: [
			editorPresenter := self 
				instantiate: aViewModel pulsarEditorClass 
				on: aViewModel.
			self 
				addPresenter: editorPresenter 
				at: (anActivation hasDesiredPosition 
					ifTrue: [ anActivation desiredPosition ]
					ifFalse:[ editorPresenter panelPosition ]).
			self viewDocked: editorPresenter ].
	
	editorPresenter activateWith: anActivation
]

{ #category : 'private' }
PulsarBaseBrowser >> maybeUndockView: aViewModel [

	aViewModel hasPulsarEditor ifFalse: [ ^ self ].

	(self findEditorContaining: aViewModel) 
		ifNotNil: [ :panelPresenter | panelPresenter close ]
]

{ #category : 'private' }
PulsarBaseBrowser >> mutex [

	^  mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private' }
PulsarBaseBrowser >> notificationCenter [
	"using my own announcer as notification center"
	^ self announcer
]

{ #category : 'accessing' }
PulsarBaseBrowser >> panels [
	"from my list of presenters, answer those who are NOT containing an editor.
	 Notice that the answer will be a list os SpPanelWidgetPresenter, containing 
	 the editor presenter, no the presenter itself."

	^ self mutex critical: [ 
		super presenters reject: [ :each | each panelArea = SpPanelArea center ] ]
]

{ #category : 'accessing - snapshot' }
PulsarBaseBrowser >> postRestoreSnapshot: aSnapshot [
]

{ #category : 'private' }
PulsarBaseBrowser >> presenterWithClass: aClass [
	"used for testing"

	^ self presenters 
		detect: [ :each | each presenter class = aClass ]
		ifNone: [ nil ]
]

{ #category : 'private' }
PulsarBaseBrowser >> presenterWithTitle: aString [

	^ self presenters 
		detect: [ :each | each title = aString ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
PulsarBaseBrowser >> presenters [
 
	^  self mutex critical: [ super presenters ]
]

{ #category : 'private' }
PulsarBaseBrowser >> presentersWithClass: aClass [
	"used for testing"

	^ self presenters 
		select: [ :each | each presenter class = aClass ]
]

{ #category : 'initialization' }
PulsarBaseBrowser >> registerToEvents [

	self announcer 
		"first broadcast"
		when: PulsarThemeChanged, PulsarSyntaxHighlightThemeChanged, PulsarAnnouncement
			send: #resendAnnouncement:
			to: self;
		"now process here"
		when: PulsarModelActivated send: #eventModelActivated: to: self;
		when: PulsarModelDeactivated send: #eventModelDeactivated: to: self;
		when: PulsarManyModelDeactivated send: #eventManyModelDeactivated: to: self;
		when: PulsarRequestToolAnnouncement send: #addTool: to: self
]

{ #category : 'initialization' }
PulsarBaseBrowser >> registerToSystemEvents [

	self announcer 
		when: JobStart send: #eventJobStart: to: self;
		when: JobEnd send: #eventJobEnd: to: self;
		when: SystemAnnouncement, MetacelloExecutionAnnouncement 
			send: #resendAnnouncement: 
			to: self
]

{ #category : 'private' }
PulsarBaseBrowser >> removeStatusbarPresenter: aPresenter [
	"As the job will require to add a spinner, we need to implement this"

	self statusbar remove: aPresenter
]

{ #category : 'announcing' }
PulsarBaseBrowser >> resendAnnouncement: anAnnouncement [
	
	self presentersDo: [ :aWindowPresenter |
		aWindowPresenter presenter announce: anAnnouncement ]
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> saveImage [

	"I need to fork because otherwise resume will try to start from here"
	[ Smalltalk snapshot: true andQuit: false ] 
	fork.

	self inform: 'Image saved'
]

{ #category : 'private' }
PulsarBaseBrowser >> scheduleJob: aBlock [
	"schedule a task that will show the working spinner while it executes"

	self scheduleTask: [
		self jobStart.
		[ aBlock cull: self statusbar ]
		ensure: [ 
			self statusbar clearMessage.
			self jobEnd ] ]
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> showSpotterOn: anOption [
	| spotter |

	spotter := self
		instantiate: PulsarSpotter 
		on: (PulsarSpotterModel 
			newEnvironment: self model environmentModel 
			origin: self).
	
	spotter notificationCenter: self notificationCenter.
	spotter initialOption: anOption.
	
	spotter openModalWithParent: self
]

{ #category : 'accessing - snapshot' }
PulsarBaseBrowser >> snapshot [

	^ PulsarBaseBrowserSnapshot on: self
]

{ #category : 'accessing' }
PulsarBaseBrowser >> systemNavigation [

	^ PulsarSystemNavigation newWindow: self
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> togglePanelArea: aPanelArea [

	aPanelArea accept: (PulsarBrowserPanelAreaVisible on: self)
]

{ #category : 'private' }
PulsarBaseBrowser >> viewDocked: aPresenter [
	"override this if browser wants to act on a view docked to it"
]

{ #category : 'private' }
PulsarBaseBrowser >> windowClosed [

	self presenters do: [ :each | each windowClosed ].
	self cleanUpSchedulers.
	super windowClosed
]

{ #category : 'private' }
PulsarBaseBrowser >> windowWillClose [

	^ true
]
