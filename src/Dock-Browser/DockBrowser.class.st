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
DockBrowser class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #perspective with: { 
		"open default tool"
		Character cr shift -> DockShowSpotterForEnvironmentCommand new.
		Character cr shift mod1 -> DockShowSpotterForWindowsCommand new.
		"Character mod1 mod3 -> PvShowSpotterForCommandsAction new" }
]

{ #category : 'private - testing' }
DockBrowser class >> hasSnapshot [

	^ LastSnapshot isNotNil
]

{ #category : 'accessing' }
DockBrowser >> addPresenterClass: aClass [
	| view |

	view := self instantiate: aClass.
	self addPresenter: view at: view dockPosition.
	
	^ view
]

{ #category : 'accessing' }
DockBrowser >> addPresenterClass: aClass model: aModel [
	| view |

	view := self instantiate: aClass on: aModel.
	self addPresenter: view at: view dockPosition.
	
^ view
]

{ #category : 'accessing' }
DockBrowser >> addPresenterClass: aClass position: aDockPosition [
	| view |

	view := self instantiate: aClass.
	self addPresenter: view at: aDockPosition.
	
	^ view
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

{ #category : 'private' }
DockBrowser >> findEditorContaining: aViewModel [

	^ self editors 
		detect: [ :each | each presenter model = aViewModel ]
		ifNone: [ nil ]
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
	{ DockStackView. DockPlayground. DockTranscript } 
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
DockBrowser >> presenterWithClass: aClass [
	"used for testing"

	^ self presenters 
		detect: [ :each | each presenter class = aClass ]
		ifNone: [ nil ]
]

{ #category : 'private' }
DockBrowser >> presenterWithTitle: aString [

	^ self presenters 
		detect: [ :each | each title = aString ]
		ifNone: [ nil ]
]

{ #category : 'private' }
DockBrowser >> projectView [

	^ projectView
]

{ #category : 'accessing - snapshot' }
DockBrowser >> snapshot [

	^ DockBrowserSnapshot on: self
]

{ #category : 'initialization' }
DockBrowser >> updateTitle [
	| newTitle |

	newTitle := self composeTitle.
	logger trace: newTitle.
	self title: newTitle
]

{ #category : 'event handling' }
DockBrowser >> windowClosed [

	self presenters 
		do: [ :each | each windowClosed ].
	super windowClosed
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
