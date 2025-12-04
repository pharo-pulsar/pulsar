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
DockDebugger >> eventContextChanged: anAnnouncement [
	
	"resend to inner presenters"
	self resendAnnouncement: anAnnouncement.
	
	"now refresh the stack"	
	self model resetStack.
	"and update it"
	self stackView updatePresenter
]

{ #category : 'events' }
DockDebugger >> eventModelActivated: anAnnouncement [
	
	"not doing this for the moment (let's first make the debugger work)"
	
	"contextEditor beFixedToDock."
	"setting contextEditor to nil will ensure a new one is created in next selection (keeping 
	 current one as 'fixed' one."
	"contextEditor := nil"
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

	super initializeWorkspace.

	self startWidth: 380.
	self bottomHeight: 300.
	debugToolbarPresenter := (self instantiate: DockDebuggerToolbarPresenter on: self model)
		debugger: self;
		yourself.
			
	stackView := self addPresenterClass: DockContextStackPresenter.

	"this will be created dynamically, do not add it here.
	 contextEditor := self addPresenterClass: DockContextEditor."
	 
	"self addPresenterClass: DockStackView."
	self addPresenterClass: DockDebuggerInspector
]

{ #category : 'accessing - model' }
DockDebugger >> model: aModel [

	super model: aModel.
	self debugToolbarPresenter model: nil.
	self stackView model: aModel
]

{ #category : 'initialization' }
DockDebugger >> registerToEvents [

	super registerToEvents.
	self announcer 
		"stack view updates on selection"
		when: DockModelSelected send: #eventModelSelected: to: self;
		when: DockDebuggerContextChanged send: #eventContextChanged: to: self
]

{ #category : 'accessing' }
DockDebugger >> session: aDebugSession [

	logger trace: aDebugSession.
	self model: (DockDebuggerModel 
		newEnvironment: PvEnvironmentModel onSystem 
		entity: aDebugSession)
]

{ #category : 'private - accessing' }
DockDebugger >> stackView [

	^ stackView
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

{ #category : 'private' }
DockDebugger >> windowWillClose [

	self application windowWillClose: self.
	^ true
]
