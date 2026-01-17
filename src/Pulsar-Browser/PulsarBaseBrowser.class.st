"
A base for all dock browsers (there should not be a lot, but more than one)
"
Class {
	#name : 'PulsarBaseBrowser',
	#superclass : 'SpPanelWindowPresenter',
	#traits : 'SpTModel + PulsarTSnapshot + PulsarTGlobalActionContainer',
	#classTraits : 'SpTModel classTrait + PulsarTSnapshot classTrait + PulsarTGlobalActionContainer classTrait',
	#instVars : [
		'actions',
		'mutex',
		'job'
	],
	#classInstVars : [
		'lastWindowSize'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing - defaults' }
PulsarBaseBrowser class >> defaultWindowSize [

	^ 1000@800
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

{ #category : 'private' }
PulsarBaseBrowser >> addGlobalActionsTo: aWindowPresenter [

	self globalActions 
		ifNotNil: [ :aGroup | aWindowPresenter actions: aGroup ]
]

{ #category : 'accessing' }
PulsarBaseBrowser >> addPresenterClass: aClass [
	| view |

	view := self instantiate: aClass.
	self addPresenter: view at: view panelPosition.
	
	^ view
]

{ #category : 'accessing' }
PulsarBaseBrowser >> addPresenterClass: aClass model: aModel [
	| view |

	view := self instantiate: aClass on: aModel.
	self addPresenter: view at: view panelPosition.
	
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
PulsarBaseBrowser >> addTool: ann [

	self addPresenterClass: ann toolClass
]

{ #category : 'private' }
PulsarBaseBrowser >> addWindow: aWindow [

	self mutex critical: [ 
		aWindow presenter registerToBrowser: self.
		super addWindow: aWindow.
		aWindow raise ]
]

{ #category : 'private - definitions' }
PulsarBaseBrowser >> defineExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #extra with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'New Payground';
			description: 'Open a new playground';
			action: [ self doNewPlayground ] ] ]
]

{ #category : 'private - actions' }
PulsarBaseBrowser >> doNewPlayground [

	self notificationCenter announce: PulsarRequestNewPlayground
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

{ #category : 'accessing - jobs' }
PulsarBaseBrowser >> jobEnd [

	job ifNil: [ ^ self ].
	job end
]

{ #category : 'accessing - jobs' }
PulsarBaseBrowser >> jobStart [

	job ifNil: [ job := PulsarJobHandler on: self ].
	job start
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
					ifFalse:[ editorPresenter panelPosition ]) ].
	
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
		when: SystemAnnouncement send: #resendAnnouncement: to: self
]

{ #category : 'private' }
PulsarBaseBrowser >> remove: aPanelWindowPresenter [

	aPanelWindowPresenter forceClose
]

{ #category : 'announcing' }
PulsarBaseBrowser >> resendAnnouncement: anAnnouncement [

	logger trace: anAnnouncement.
	
	self presentersDo: [ :aWindowPresenter |
		aWindowPresenter presenter announce: anAnnouncement ]
]

{ #category : 'private - schedulling' }
PulsarBaseBrowser >> schedule: aBlock [

	self 
		deprecated: 'This is confusing, use #scheduleTask:' 
		transformWith: 
			'`@receiver schedule: `@arg' -> 
			'`@receiver scheduleTask: `@arg'.

	^ self scheduleTask: aBlock
]

{ #category : 'private - schedulling' }
PulsarBaseBrowser >> scheduleTask: aBlock [

	^ self application scheduleTask: aBlock
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
PulsarBaseBrowser >> windowClosed [

	self presenters do: [ :each | each windowClosed ].
	announcer stopTaskWorker.
	super windowClosed
]

{ #category : 'private' }
PulsarBaseBrowser >> windowWillClose [

	^ true
]
