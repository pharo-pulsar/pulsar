Class {
	#name : 'DockDebugger',
	#superclass : 'DockBaseBrowser',
	#instVars : [
		'stackView',
		'contextEditor'
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

{ #category : 'api - focus' }
DockDebugger >> defaultKeyboardFocus [

	^ stackView
]

{ #category : 'events' }
DockDebugger >> eventModelActivated: anAnnouncement [
	
	self flag: #TODO. "open model in new context editor when activated :P"
]

{ #category : 'events' }
DockDebugger >> eventModelSelected: anAnnouncement [
	| contextModel |
	
	contextModel := anAnnouncement value.
	logger trace: contextModel.
	contextEditor model: contextModel
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

	stackView := self addPresenterClass: DockContextStackPresenter.
	contextEditor := self addPresenterClass: DockContextEditor
]

{ #category : 'accessing - model' }
DockDebugger >> model: aModel [

	super model: aModel.
	stackView model: aModel
]

{ #category : 'initialization' }
DockDebugger >> registerToEvents [

	super registerToEvents.
	self announcer 
		"stack view updates on selection"
		when: DockModelSelected send: #eventModelSelected: to: self
]

{ #category : 'accessing' }
DockDebugger >> session: aDebugSession [

	logger trace: aDebugSession.
	self model: (DockDebuggerModel 
		newEnvironment: PvEnvironmentModel onSystem 
		entity: aDebugSession)
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

{ #category : 'event handling' }
DockDebugger >> windowWillClose [
	self application windowWillClose: self.
	^ true
]
