Trait {
	#name : 'DockTPanelWindow',
	#instVars : [
		'dockPosition',
		'lastTimePresented'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'defaults' }
DockTPanelWindow classSide >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea center;
		yourself
]

{ #category : 'accessing' }
DockTPanelWindow >> dockPosition [

	^ dockPosition ifNil: [ dockPosition := self class defaultDockPosition ]
]

{ #category : 'accessing' }
DockTPanelWindow >> dockPosition: aDockPosition [

	dockPosition := aDockPosition
]

{ #category : 'initialization' }
DockTPanelWindow >> initializePanelWindow: aWindowPresenter [

	super initializePanelWindow: aWindowPresenter.
	aWindowPresenter 
		whenPresentedDo: [ self recordLastPresented ];
		whenFocusReceivedDo: [ self notifyEditorActivated ]
]

{ #category : 'initialization' }
DockTPanelWindow >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model fullName;
		whenClosedDo: [ self notifyEditorClosed  ]
]

{ #category : 'initialization' }
DockTPanelWindow >> notifyEditorActivated [

	self notificationCenter announce: (DockToolEditorActivated newValue: self)
]

{ #category : 'initialization' }
DockTPanelWindow >> notifyEditorClosed [
	self notificationCenter announce: (DockEditorClosed newValue: self model)
]

{ #category : 'private' }
DockTPanelWindow >> recordLastPresented [

	lastTimePresented := DateAndTime now
]
