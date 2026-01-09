Trait {
	#name : 'PulsarTPanelWindow',
	#instVars : [
		'lastTimePresented',
		'panelPosition'
	],
	#traits : 'PulsarTPanelWindowWithPlacedIcon',
	#classTraits : 'PulsarTPanelWindowWithPlacedIcon classTrait',
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'defaults' }
PulsarTPanelWindow classSide >> defaultPanelPosition [

	^ SpPanelPosition centerArea
]

{ #category : 'private - actions' }
PulsarTPanelWindow >> activateWith: anActivation [
	"override to react to an activation detail"
]

{ #category : 'initialization' }
PulsarTPanelWindow >> initializePanelWindow: aWindowPresenter [

	super initializePanelWindow: aWindowPresenter.
	aWindowPresenter 
		whenPresentedDo: [ self recordLastPresented ];
		whenFocusReceivedDo: [ self notifyEditorActivated ];
		whenPlacedDo: [ self panelPlaced: aWindowPresenter ]
]

{ #category : 'initialization' }
PulsarTPanelWindow >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model fullName;
		whenClosedDo: [ self notifyEditorClosed  ]
]

{ #category : 'accessing' }
PulsarTPanelWindow >> lastTimePresented [

	^ lastTimePresented
]

{ #category : 'private' }
PulsarTPanelWindow >> lastTimePresented: aDateAndTime [

	lastTimePresented := aDateAndTime
]

{ #category : 'initialization' }
PulsarTPanelWindow >> notifyEditorActivated [

	self notificationCenter announce: (PulsarToolEditorActivated newValue: self)
]

{ #category : 'initialization' }
PulsarTPanelWindow >> notifyEditorClosed [

	self notificationCenter announce: (PulsarEditorClosed newValue: self model)
]

{ #category : 'accessing' }
PulsarTPanelWindow >> panelPosition [

	^ panelPosition ifNil: [ panelPosition := self class defaultPanelPosition ]
]

{ #category : 'accessing' }
PulsarTPanelWindow >> panelPosition: aPanelPosition [

	panelPosition := aPanelPosition
]

{ #category : 'accessing' }
PulsarTPanelWindow >> raise [

	self withPanelWindowDo: [ :aWindow | 
		aWindow raiseAndTakeKeyboardFocus ]
]

{ #category : 'private' }
PulsarTPanelWindow >> recordLastPresented [

	self lastTimePresented: DateAndTime now
]
