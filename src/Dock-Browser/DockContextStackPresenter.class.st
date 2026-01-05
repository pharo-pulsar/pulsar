Class {
	#name : 'DockContextStackPresenter',
	#superclass : 'DockCollectionView',
	#traits : 'DockTPanelWindowWithPlacedIcon',
	#classTraits : 'DockTPanelWindowWithPlacedIcon classTrait',
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'defaults' }
DockContextStackPresenter class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea start;
		row: 1;
		yourself
]

{ #category : 'layout' }
DockContextStackPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: listPresenter;
		yourself
]

{ #category : 'accessing' }
DockContextStackPresenter >> dockPosition [

	^ self class defaultDockPosition
]

{ #category : 'private' }
DockContextStackPresenter >> findFirstRelevantStackIndex [
	| counter |
	
	counter := 1.
	listPresenter items do: [ :contextModel | 
		contextModel methodClass == TestAsserter 
			ifFalse: [ ^ counter ].
		counter := counter + 1 ].
	
	^ 1
]

{ #category : 'initialization' }
DockContextStackPresenter >> initializePanelWindow: aWindowPresenter [

	super initializePanelWindow: aWindowPresenter.
	aWindowPresenter 
		whenPlacedDo: [ self panelPlaced: aWindowPresenter ]
]

{ #category : 'initialization' }
DockContextStackPresenter >> initializePresenters [

	self addStyle: 'dockDebugger'.
	listPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockContextStackList';
		display: [ :aModel | aModel name ];
		yourself
]

{ #category : 'initialization' }
DockContextStackPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Stack';
		windowIcon: (self iconNamed: self panelPlacedIconName)
]

{ #category : 'private' }
DockContextStackPresenter >> panelPlacedIconName [

	^ 'stack'
]

{ #category : 'api - selection' }
DockContextStackPresenter >> selectFirst [ 

	listPresenter selectFirst
]

{ #category : 'api - selection' }
DockContextStackPresenter >> selectFirstRelevantStackIndex [
	
	listPresenter 
		selectIndex: self findFirstRelevantStackIndex 
		scrollToSelection: true
]

{ #category : 'accessing' }
DockContextStackPresenter >> selectedContextModel [

	^ listPresenter selectedItem
]

{ #category : 'initialization' }
DockContextStackPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [
		listPresenter items: self model stack.
		self selectFirstRelevantStackIndex ]
]
