Class {
	#name : 'DockBaseBrowser',
	#superclass : 'SpPanelWindowPresenter',
	#traits : 'SpTModel + DockTSnapshot + DockTGlobalActionContainer',
	#classTraits : 'SpTModel classTrait + DockTSnapshot classTrait + DockTGlobalActionContainer classTrait',
	#instVars : [
		'actions',
		'mutex'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing - actions' }
DockBaseBrowser class >> definePanelActionGroup: actionGroup [
	<perspectiveActionGroup: #panels>
	
	actionGroup 
		name: 'Panels';
		priority: 900;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
DockBaseBrowser class >> definePanelActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #panels with: { 
		SpAction new 
			name: 'Toggle panel left';
			description: 'Show/hide the left panel';
			iconName: 'panel-left';
			action: [ :aContext | aContext togglePanelArea: SpPanelArea start ].
		SpAction new 
			name: 'Toggle panel top'; 
			description: 'Show/hide the top panel';
			iconName: 'panel-top';
			action: [ :aContext | aContext togglePanelArea: SpPanelArea top ].
		SpAction new 
			name: 'Toggle panel right'; 
			description: 'Show/hide the right panel';
			iconName: 'panel-right';
			action: [ :aContext | aContext togglePanelArea: SpPanelArea end ].
		SpAction new 
			name: 'Toggle panel bottom'; 
			description: 'Show/hide the bottom panel';
			iconName: 'panel-bottom';
			action: [ :aContext | aContext togglePanelArea: SpPanelArea bottom ].
	}
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
DockBaseBrowser >> addWindow: aWindow [

	self mutex critical: [ 
		aWindow presenter registerToDock: self.
		super addWindow: aWindow.
		aWindow raise ]
]

{ #category : 'accessing' }
DockBaseBrowser >> editors [

	^ self mutex critical: [ 
		super presenters select: [ :each | each dockArea = SpPanelArea center ] ]
]

{ #category : 'events' }
DockBaseBrowser >> eventManyModelDeactivated: anAnnouncement [
]

{ #category : 'events' }
DockBaseBrowser >> eventModelActivated: anAnnouncement [
	
]

{ #category : 'events' }
DockBaseBrowser >> eventModelDeactivated: anAnnouncement [
]

{ #category : 'private' }
DockBaseBrowser >> findEditorContaining: aViewModel [

	^ self editors 
		detect: [ :each | each presenter model = aViewModel ]
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
	self registerToEvents
]

{ #category : 'private - initialization' }
DockBaseBrowser >> initializePrivateAnnouncer [

  announcer := DockTaskAnnouncer new
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
	self addGlobalActionsTo: self
]

{ #category : 'initialization' }
DockBaseBrowser >> initializeWorkspace [
	
	self initializeStatusbar
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
		when: DockThemeChanged, DockSyntaxHighlightThemeChanged
			send: #resendAnnouncement:
			to: self;
		when: DockAnnouncement send: #resendAnnouncement: to: self;
		"now process here"
		when: DockModelActivated send: #eventModelActivated: to: self;
		when: DockModelDeactivated send: #eventModelDeactivated: to: self;
		when: DockManyModelDeactivated send: #eventManyModelDeactivated: to: self
]

{ #category : 'announcing' }
DockBaseBrowser >> resendAnnouncement: anAnnouncement [
	
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

{ #category : 'accessing - snapshot' }
DockBaseBrowser >> snapshot [

	^ DockBrowserSnapshot on: self
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
