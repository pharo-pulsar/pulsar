Class {
	#name : 'PulsarDebugger',
	#superclass : 'PulsarBaseBrowser',
	#instVars : [
		'stackView',
		'contextEditor',
		'debugToolbarPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'instance creation' }
PulsarDebugger >> debugSession: aDebugSession [

	logger trace: aDebugSession.
	
	self session: aDebugSession.
	self open
]

{ #category : 'accessing' }
PulsarDebugger >> debugToolbarPresenter [

	^ debugToolbarPresenter
]

{ #category : 'api - focus' }
PulsarDebugger >> defaultKeyboardFocus [

	^ stackView
]

{ #category : 'private - definitions' }
PulsarDebugger >> defineViewActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #view with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Class Outline';
			description: 'Open a class outline panel';
			actionState: [ self hasPresenterClass: PulsarClassOutlineView ];
			action: [ self doOpenClassOutlineView ] ];
		addActionWith: [ :action | action 
			name: 'Editor Stack';
			description: 'Open the editor stack panel';
			actionState: [ self hasPresenterClass: PulsarStackView ];
			action: [ self doOpenEditorStackView ] ] ]
]

{ #category : 'private - actions' }
PulsarDebugger >> doOpenClassOutlineView [
	| outlineView |

	outlineView := self ensureClassOutlineOverview.
	outlineView takeKeyboardFocus
]

{ #category : 'private - actions' }
PulsarDebugger >> doOpenEditorStackView [
	
	
]

{ #category : 'events' }
PulsarDebugger >> eventContextChanged: anAnnouncement [
	
	"resend to inner presenters"
	self resendAnnouncement: anAnnouncement.
	
	"now refresh the stack"	
	self model resetStack.
	"and update it"
	self stackView updatePresenter
]

{ #category : 'events' }
PulsarDebugger >> eventModelActivated: anAnnouncement [
	
	self flag: #TODO. "Find a better way than filter by class"
	(anAnnouncement value class = PulsarContextModel) ifTrue: [ ^ self] .

	"not doing this for the moment (let's first make the debugger work)"
	
	"contextEditor beFixedToPulsar."
	"setting contextEditor to nil will ensure a new one is created in next selection (keeping 
	 current one as 'fixed' one."
	"contextEditor := nil"
	
	super eventModelActivated: anAnnouncement

]

{ #category : 'events' }
PulsarDebugger >> eventModelSelected: anAnnouncement [
	| selectedModel |
	
	selectedModel := anAnnouncement value.
	selectedModel isContextModel ifFalse: [ ^ self ].

	contextEditor ifNil: [
		contextEditor := self addPresenterClass: PulsarContextEditor ].
	logger trace: selectedModel.
	contextEditor model: selectedModel.
	debugToolbarPresenter updatePresenter
]

{ #category : 'initialization' }
PulsarDebugger >> initializeDefaultWorkspace [

	stackView := self addPresenterClass: PulsarContextStackPresenter.

	self addPresenterClass: PulsarDebuggerReceiverInspector.
	self addPresenterClass: PulsarDebuggerContextInspector
]

{ #category : 'initialization' }
PulsarDebugger >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter
]

{ #category : 'initialization' }
PulsarDebugger >> initializeWorkspace [

	super initializeWorkspace.

	self startWidth: 380.
	self bottomHeight: 300.
	
	debugToolbarPresenter := (self instantiate: PulsarDebuggerToolbarPresenter)
		debugger: self;
		yourself
]

{ #category : 'accessing - model' }
PulsarDebugger >> model: aModel [

	super model: aModel.
	self debugToolbarPresenter model: nil.
	self stackView model: aModel
]

{ #category : 'accessing - snapshot' }
PulsarDebugger >> postRestoreSnapshot: aSnapshot [
			
 	stackView := self presenters
		detect: [ :each | each presenter class = PulsarContextStackPresenter ]
		ifFound: [ :each | each presenter ]
		ifNone: [ self addPresenterClass: PulsarContextStackPresenter ]
]

{ #category : 'initialization' }
PulsarDebugger >> registerToEvents [

	super registerToEvents.
	self announcer 
		"stack view updates on selection"
		when: PulsarModelSelected send: #eventModelSelected: to: self;
		when: PulsarDebuggerContextChanged send: #eventContextChanged: to: self
]

{ #category : 'accessing' }
PulsarDebugger >> session: aDebugSession [

	logger trace: aDebugSession.
	self model: (PulsarDebuggerModel 
		newEnvironment: PvEnvironmentModel onSystem 
		entity: aDebugSession)
]

{ #category : 'accessing - snapshot' }
PulsarDebugger >> snapshot [

	^ PulsarDebuggerSnapshot on: self
]

{ #category : 'private - accessing' }
PulsarDebugger >> stackView [

	^ stackView
]

{ #category : 'initialization' }
PulsarDebugger >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self updateTitle
]

{ #category : 'initialization' }
PulsarDebugger >> updateTitle [

	self withWindowDo: [ :aWindow | aWindow title: self model name ]
]

{ #category : 'private' }
PulsarDebugger >> viewDocked: aPresenter [

	(PulsarBrowserEnsureClassOverviewVisitor on: self) visit: aPresenter
]

{ #category : 'private' }
PulsarDebugger >> windowClosed [
	
	super windowClosed.
	self model clearSession
]

{ #category : 'private' }
PulsarDebugger >> windowWillClose [

	self application windowWillClose: self.
	^ true
]
