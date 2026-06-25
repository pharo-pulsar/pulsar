Trait {
	#name : 'PulsarTPanelWindow',
	#instVars : [
		'lastTimePresented',
		'panelPosition',
		'pinned'
	],
	#traits : 'PulsarTActionContainer',
	#classTraits : 'PulsarTActionContainer classTrait',
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

{ #category : 'private - actions' }
PulsarTPanelWindow >> doDetachWindow [
	| newBrowser panelWindow |

	newBrowser := PulsarDetachedBrowser 
		newApplication: self application 
		model: self window model.
	panelWindow := self panelWidget.
	
	"it seems to look better if I open it first (the visualisation effect is nicer)"
	newBrowser open.
	newBrowser 
		moveWindow: panelWindow 
		from: self window
]

{ #category : 'initialization' }
PulsarTPanelWindow >> initializePanelWidget: aPanelWidgetPresenter [
	"WARNING: if you override this method, you need to call the associated initialize method 
	 (make sure all the required events are mapped)"

	super initializePanelWidget: aPanelWidgetPresenter.
	aPanelWidgetPresenter actions: self panelWidgetActions.
	self registerToPanelWidgetEvents: aPanelWidgetPresenter
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

{ #category : 'private' }
PulsarTPanelWindow >> maybeActivateIconOnPanel: aPanelWidgetPresenter [
	| inHorizontalArea iconName |

	iconName := self panelPlacedIconName.
	iconName ifNil: [ ^ self ].
		
	inHorizontalArea := { SpPanelArea top. SpPanelArea bottom } includes: aPanelWidgetPresenter panelArea.
	aPanelWidgetPresenter windowIcon: (inHorizontalArea
		ifTrue: [ self iconNamed: iconName ]
		ifFalse: [ nil ])
]

{ #category : 'initialization' }
PulsarTPanelWindow >> notifyEditorActivated [

	self notificationCenter announce: (PulsarToolEditorActivated newValue: self)
]

{ #category : 'initialization' }
PulsarTPanelWindow >> notifyEditorClosed [

	self notificationCenter announce: (PulsarEditorClosed newValue: self model)
]

{ #category : 'private' }
PulsarTPanelWindow >> panelFocused [

	logger trace.
	self notifyEditorActivated
]

{ #category : 'private' }
PulsarTPanelWindow >> panelModifiedChanged [
]

{ #category : 'private' }
PulsarTPanelWindow >> panelPlaced: aPanelWidgetPresenter [
	
	logger trace.
	self maybeActivateIconOnPanel: aPanelWidgetPresenter
]

{ #category : 'private' }
PulsarTPanelWindow >> panelPlacedIconName [

	^ nil
]

{ #category : 'accessing' }
PulsarTPanelWindow >> panelPosition [

	^ panelPosition ifNil: [ panelPosition := self class defaultPanelPosition ]
]

{ #category : 'accessing' }
PulsarTPanelWindow >> panelPosition: aPanelPosition [

	panelPosition := aPanelPosition
]

{ #category : 'private' }
PulsarTPanelWindow >> panelPresented [

	logger trace.
	self recordLastPresented.
	self panelFocused
]

{ #category : 'private' }
PulsarTPanelWindow >> panelTransferredFrom: fromWindow to: toWindow [
	| isEditor |

	isEditor := self isEditor.
	
	logger trace: isEditor.
	
	self registerToBrowser: toWindow.
	isEditor ifTrue: [
		fromWindow notificationCenter announce: (PulsarEditorClosed newValue: self).
		toWindow notificationCenter announce: (PulsarEditorActivated newValue: self) ]
]

{ #category : 'private' }
PulsarTPanelWindow >> panelWidgetActions [

	^ self actions actionsFor: #panelWidget
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

{ #category : 'initialization' }
PulsarTPanelWindow >> registerToPanelWidgetEvents: aPanelWidgetPresenter [

	aPanelWidgetPresenter	
		whenPresentedDo: [ self panelPresented ];
		whenFocusReceivedDo: [ self panelFocused ];
		whenModifiedChangedDo: [ self panelModifiedChanged ];
		whenPlacedDo: [ self panelPlaced: aPanelWidgetPresenter ];
		whenTransferredDo: [ :ann | self panelTransferredFrom: ann fromWindow to: ann toWindow ]
]
