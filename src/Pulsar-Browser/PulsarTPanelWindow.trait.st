Trait {
	#name : 'PulsarTPanelWindow',
	#instVars : [
		'lastTimePresented',
		'panelPosition',
		'pinned'
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

{ #category : 'definitions' }
PulsarTPanelWindow classSide >> defineWindowActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #panelWidget with: [ :group | group
		priority: 1010;
		name: 'Window';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			name: 'Maximize';
			description: 'Maximize current window';
			action: [ :aContext | aContext withPanelWidgetDo: #maximize ] ];		
		addActionWith: [ :action | action
			name: 'Detach';
			shortcutKey: Character arrowUp alt shift;
			description: 'Detach this window from this browser (open a new window)';
			action: [ :aContext | aContext doDetachWindow ] ] ]
]

{ #category : 'private - actions' }
PulsarTPanelWindow >> activateWith: anActivation [
	"override to react to an activation detail"
]

{ #category : 'initialization' }
PulsarTPanelWindow >> initializePanelWidget: aPanelWidgetPresenter [

	super initializePanelWidget: aPanelWidgetPresenter.
	aPanelWidgetPresenter
		whenPresentedDo: [ self recordLastPresented ];
		whenFocusReceivedDo: [ self notifyEditorActivated ]
]

{ #category : 'initialization' }
PulsarTPanelWindow >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model 
			ifNotNil: [ :aModel | aModel fullName ] 
			ifNil: [ 'NONAME' ]);
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'testing' }
PulsarTPanelWindow >> isDirty [
	
	^ false
]

{ #category : 'testing' }
PulsarTPanelWindow >> isPinned [
	
	^ pinned ifNil: [ pinned := false ]
]

{ #category : 'accessing' }
PulsarTPanelWindow >> lastTimePresented [

	^ lastTimePresented ifNil: [ lastTimePresented := DateAndTime now ]
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
PulsarTPanelWindow >> pinned: aBoolean [

	pinned := aBoolean
]

{ #category : 'accessing' }
PulsarTPanelWindow >> raise [

	self withPanelWidgetDo: [ :aWindow | 
		aWindow raiseAndTakeKeyboardFocus ]
]

{ #category : 'private' }
PulsarTPanelWindow >> recordLastPresented [

	self lastTimePresented: DateAndTime now
]
