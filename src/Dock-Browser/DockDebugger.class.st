Class {
	#name : 'DockDebugger',
	#superclass : 'DockBaseBrowser',
	#instVars : [
		'stackView',
		'contextEditor',
		'debugToolbarPresenter'
	],
	#classVars : [
		'LastWindowSize'
	],
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'testing' }
DockDebugger >> canExecuteDebugCommand [

	^ self model 
		ifNotNil: [ :aModel | aModel canExecuteDebugCommand ]
		ifNil: [ false ]
]

{ #category : 'testing' }
DockDebugger >> canExecuteRestartCommand [

	^ self model 
		ifNotNil: [ :aModel | aModel canExecuteRestartCommand ]
		ifNil: [ false ]
]

{ #category : 'testing' }
DockDebugger >> canExecuteReturnCommand [

	^ self model 
		ifNotNil: [ :aModel | aModel canExecuteReturnCommand ]
		ifNil: [ false ]
]

{ #category : 'instance creation' }
DockDebugger >> debugSession: aDebugSession [

	logger trace: aDebugSession.
	self session: aDebugSession.

	self open
]

{ #category : 'accessing' }
DockDebugger >> debugToolbarPresenter [

	^ debugToolbarPresenter
]

{ #category : 'api - focus' }
DockDebugger >> defaultKeyboardFocus [

	^ stackView
]

{ #category : 'events' }
DockDebugger >> eventModelActivated: anAnnouncement [
	
	"self eventModelSelected: anAnnouncement."
	contextEditor beFixedToDock.
	"setting contextEditor to nil will ensure a new one is created in next selection (keeping 
	 current one as 'fixed' one."
	contextEditor := nil
]

{ #category : 'events' }
DockDebugger >> eventModelSelected: anAnnouncement [
	| contextModel |
	
	contextModel := anAnnouncement value.

	contextEditor ifNil: [
		contextEditor := self addPresenterClass: DockContextEditor ].
	logger trace: contextModel.
	contextEditor model: contextModel.
	debugToolbarPresenter updatePresenter
]

{ #category : 'initialization' }
DockDebugger >> initializeWindow: aWindowPresenter [

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
DockDebugger >> initializeWorkspace [

	self startWidth: 380.
	debugToolbarPresenter := (self instantiate: DockDebuggerToolbarPresenter)
		debugger: self;
		yourself.
			
	stackView := self addPresenterClass: DockContextStackPresenter.

	"this will be created dynamically, do not add it here.
	 contextEditor := self addPresenterClass: DockContextEditor."
	 
	self addPresenterClass: DockStackView
]

{ #category : 'accessing - model' }
DockDebugger >> model: aModel [

	super model: aModel.
	stackView model: aModel
]

{ #category : 'actions' }
DockDebugger >> proceedDebugSession [ 

	self model proceedDebugSession
]

{ #category : 'initialization' }
DockDebugger >> registerToEvents [

	super registerToEvents.
	self announcer 
		"stack view updates on selection"
		when: DockModelSelected send: #eventModelSelected: to: self
]

{ #category : 'actions' }
DockDebugger >> runToSelection [
 
	"^ self model 
		runToSelection: contextEditor selectionInterval
		inContext: stackView selectedContextModel"
]

{ #category : 'accessing' }
DockDebugger >> session: aDebugSession [

	logger trace: aDebugSession.
	self model: (DockDebuggerModel 
		newEnvironment: PvEnvironmentModel onSystem 
		entity: aDebugSession)
]

{ #category : 'actions' }
DockDebugger >> stepInto [

	^ self model stepInto: stackView selectedContextModel
]

{ #category : 'actions' }
DockDebugger >> stepOver [

	^ self model stepOver: stackView selectedContextModel
]

{ #category : 'actions' }
DockDebugger >> stepThrough [

	^ self model stepThrough: stackView selectedContextModel
]

{ #category : 'initialization' }
DockDebugger >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self updateTitle
]

{ #category : 'initialization' }
DockDebugger >> updateTitle [

	self withWindowDo: [ :aWindow | aWindow title: self model name ]
]

{ #category : 'private' }
DockDebugger >> windowClosed [
	
	super windowClosed.
	self model clearSession
]

{ #category : 'event handling' }
DockDebugger >> windowWillClose [
	self application windowWillClose: self.
	^ true
]
