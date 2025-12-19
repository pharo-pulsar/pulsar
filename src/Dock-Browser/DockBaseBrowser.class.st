"
A base for all dock browsers (there should not be a lot, but more than one)
"
Class {
	#name : 'DockBaseBrowser',
	#superclass : 'SpPanelWindowPresenter',
	#traits : 'SpTModel + DockTSnapshot + DockTGlobalActionContainer',
	#classTraits : 'SpTModel classTrait + DockTSnapshot classTrait + DockTGlobalActionContainer classTrait',
	#instVars : [
		'actions',
		'mutex',
		'job'
	],
	#classInstVars : [
		'lastWindowSize'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing - defaults' }
DockBaseBrowser class >> defaultWindowSize [

	^ 1000@800
]

{ #category : 'accessing - actions' }
DockBaseBrowser class >> definePanelActionsOn: aBuilder [
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
DockBaseBrowser class >> lastWindowSize [

	^ lastWindowSize ifNil: [ self defaultWindowSize ]
]

{ #category : 'private - accessing' }
DockBaseBrowser class >> lastWindowSize: aPoint [

	lastWindowSize := aPoint
]

{ #category : 'instance creation' }
DockBaseBrowser class >> newApplication: anApplication model: aModel snapshot: aSnapshot [

	^ self basicNew
		application: anApplication;
		setModelBeforeInitialization: aModel;
		initializeSnapshot: aSnapshot;
		yourself
]

{ #category : 'private' }
DockBaseBrowser >> addGlobalActionsTo: aWindowPresenter [

	self globalActions 
		ifNotNil: [ :aGroup | aWindowPresenter actions: aGroup ]
]

{ #category : 'accessing' }
DockBaseBrowser >> addPresenterClass: aClass [
	| view |

	view := self instantiate: aClass.
	self addPresenter: view at: view dockPosition.
	
	^ view
]

{ #category : 'accessing' }
DockBaseBrowser >> addPresenterClass: aClass model: aModel [
	| view |

	view := self instantiate: aClass on: aModel.
	self addPresenter: view at: view dockPosition.
	
	^ view
]

{ #category : 'accessing' }
DockBaseBrowser >> addPresenterClass: aClass position: aDockPosition [
	| view |

	view := self instantiate: aClass.
	self addPresenter: view at: aDockPosition.
	
	^ view
]

{ #category : 'private' }
DockBaseBrowser >> addTool: ann [ 

	self addPresenterClass: ann toolClass
]

{ #category : 'private' }
DockBaseBrowser >> addWindow: aWindow [

	self mutex critical: [ 
		aWindow presenter registerToDock: self.
		super addWindow: aWindow.
		aWindow raise ]
]

{ #category : 'private - actions' }
DockBaseBrowser >> doShowSpotterForCommands [

	self showSpotterOn: #commands
]

{ #category : 'private - actions' }
DockBaseBrowser >> doShowSpotterForEnvironment [

	self showSpotterOn: #environment
]

{ #category : 'private - actions' }
DockBaseBrowser >> doShowSpotterForWindows [

	self showSpotterOn: #windows
]

{ #category : 'accessing' }
DockBaseBrowser >> editors [
	"from my list of presenters, answer those who are containing an editor.
	 Notice that the answer will be a list os SpPanelWidgetPresenter, containing 
	 the editor presenter, no the presenter itself."


	^ self mutex critical: [ 
		super presenters select: [ :each | each dockArea = SpPanelArea center ] ]
]

{ #category : 'events' }
DockBaseBrowser >> eventJobEnd: ann [

	self jobEnd
]

{ #category : 'events' }
DockBaseBrowser >> eventJobStart: ann [

	self jobStart
]

{ #category : 'events' }
DockBaseBrowser >> eventManyModelDeactivated: anAnnouncement [
]

{ #category : 'events' }
DockBaseBrowser >> eventModelActivated: anAnnouncement [
	
	self 
		maybeDockView: anAnnouncement value
		withActivation: anAnnouncement
]

{ #category : 'events' }
DockBaseBrowser >> eventModelDeactivated: anAnnouncement [
	
	self maybeUndockView: anAnnouncement value
]

{ #category : 'accessing' }
DockBaseBrowser >> findAllPresentersClass: aClass [
	"answer sll presenters matching the class."
	
	^ self presenter
		select: [ :each | each presenter class = aClass ]
		thenCollect: [ :each | each presenters ]
]

{ #category : 'private' }
DockBaseBrowser >> findEditorContaining: aViewModel [

	^ self editors 
		detect: [ :each | each presenter model = aViewModel ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
DockBaseBrowser >> findPresenterClass: aClass [
	"answer the first presenter matching the class.
	 since the browser can have many presenters of the same class, this is useful 
	 just in certain cases"
	
	^ self presenters
		detect: [ :each | each presenter class = aClass ]
		ifFound: [ :each | each presenter ]
		ifNone: [ nil ]
]

{ #category : 'simple dialog helpers' }
DockBaseBrowser >> inform: aString [

	logger trace: aString message: 'inform'.
	self addToast: (SpPanelToast new 
		title: aString;
		yourself)
]

{ #category : 'initialization' }
DockBaseBrowser >> initialize [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents.
	self initializeDefaultWorkspace
]

{ #category : 'initialization' }
DockBaseBrowser >> initializeDefaultWorkspace [
	"override this to add things when the browser do not come from a snapshot (not recovening)"
	
]

{ #category : 'private - initialization' }
DockBaseBrowser >> initializePrivateAnnouncer [

  announcer := DockTaskAnnouncer new
]

{ #category : 'initialization' }
DockBaseBrowser >> initializeSnapshot: aSnapshot [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents
]

{ #category : 'initialization' }
DockBaseBrowser >> initializeStatusbar [

	self statusbar addSuffix: (self newToolbar 
		displayMode: self application toolbarDisplayMode;
		fillWith: (self globalActions actionsFor: #panels))
]

{ #category : 'initialization' }
DockBaseBrowser >> initializeWindow: aWindowPresenter [

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
DockBaseBrowser >> initializeWorkspace [
	"IMPORTANT: browser initialize workspace will do just what it has always initialized 
	 **and that is not restored through a snapshot**.
	 To create the initial workspace (created without a snapshot), please override 
	 `initializeDefaultWorkspace` instead this."	
	
	self initializeStatusbar

]

{ #category : 'accessing - jobs' }
DockBaseBrowser >> jobEnd [

	job ifNil: [ ^ self ].
	job end
]

{ #category : 'accessing - jobs' }
DockBaseBrowser >> jobStart [

	job ifNil: [ job := DockJobHandler on: self ].
	job start
]

{ #category : 'private' }
DockBaseBrowser >> maybeDockView: aViewModel withActivation: anActivation [
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
DockBaseBrowser >> maybeUndockView: aViewModel [

	aViewModel hasDockEditor ifFalse: [ ^ self ].

	(self findEditorContaining: aViewModel) 
		ifNotNil: [ :panelPresenter | panelPresenter close ]
]

{ #category : 'private' }
DockBaseBrowser >> mutex [

	^  mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private' }
DockBaseBrowser >> notificationCenter [
	"using my own announcer as notification center"
	^ self announcer
]

{ #category : 'accessing - snapshot' }
DockBaseBrowser >> postRestoreSnapshot: aSnapshot [
]

{ #category : 'private' }
DockBaseBrowser >> presenterWithClass: aClass [
	"used for testing"

	^ self presenters 
		detect: [ :each | each presenter class = aClass ]
		ifNone: [ nil ]
]

{ #category : 'private' }
DockBaseBrowser >> presenterWithTitle: aString [

	^ self presenters 
		detect: [ :each | each title = aString ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
DockBaseBrowser >> presenters [
 
	^  self mutex critical: [ super presenters ]
]

{ #category : 'private' }
DockBaseBrowser >> presentersWithClass: aClass [
	"used for testing"

	^ self presenters 
		select: [ :each | each presenter class = aClass ]
]

{ #category : 'initialization' }
DockBaseBrowser >> registerToEvents [

	self announcer 
		"first broadcast"
		when: DockThemeChanged, DockSyntaxHighlightThemeChanged, DockAnnouncement
			send: #resendAnnouncement:
			to: self;
		"now process here"
		when: DockModelActivated send: #eventModelActivated: to: self;
		when: DockModelDeactivated send: #eventModelDeactivated: to: self;
		when: DockManyModelDeactivated send: #eventManyModelDeactivated: to: self
]

{ #category : 'initialization' }
DockBaseBrowser >> registerToSystemEvents [

	self announcer 
		when: JobStart send: #eventJobStart: to: self;
		when: JobEnd send: #eventJobEnd: to: self;
		when: SystemAnnouncement send: #resendAnnouncement: to: self
]

{ #category : 'announcing' }
DockBaseBrowser >> resendAnnouncement: anAnnouncement [

	logger trace: anAnnouncement.
	
	self presentersDo: [ :aWindowPresenter |
		aWindowPresenter presenter announce: anAnnouncement ]
]

{ #category : 'private - schedulling' }
DockBaseBrowser >> schedule: aBlock [

	^ self scheduler schedule: aBlock
]

{ #category : 'private - schedulling' }
DockBaseBrowser >> scheduler [

	^ self application scheduler
]

{ #category : 'private - actions' }
DockBaseBrowser >> showSpotterOn: anOption [
	| spotter |

	spotter := self
		instantiate: DockSpotter 
		on: (DockSpotterModel 
			newEnvironment: self model environmentModel 
			origin: self).
	
	spotter notificationCenter: self notificationCenter.
	spotter initialOption: anOption.
	
	spotter openModalWithParent: self
]

{ #category : 'accessing - snapshot' }
DockBaseBrowser >> snapshot [

	^ DockBaseBrowserSnapshot on: self
]

{ #category : 'accessing' }
DockBaseBrowser >> systemNavigation [

	^ DockSystemNavigation newWindow: self
]

{ #category : 'private - actions' }
DockBaseBrowser >> togglePanelArea: aPanelArea [

	aPanelArea accept: (DockBrowserPanelAreaVisible on: self)
]

{ #category : 'private' }
DockBaseBrowser >> windowClosed [

	self presenters do: [ :each | each windowClosed ].
	announcer stopScheduler.
	super windowClosed
]

{ #category : 'private' }
DockBaseBrowser >> windowWillClose [

	^ true
]
