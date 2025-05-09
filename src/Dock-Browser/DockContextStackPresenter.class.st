Class {
	#name : 'DockContextStackPresenter',
	#superclass : 'DockCollectionView',
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

	aWindowPresenter title: 'Stack'
]

{ #category : 'initialization' }
DockContextStackPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [
		listPresenter 
			items: self model stack;
			selectFirst ]
]
