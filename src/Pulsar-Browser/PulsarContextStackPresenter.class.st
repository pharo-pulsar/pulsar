Class {
	#name : 'PulsarContextStackPresenter',
	#superclass : 'PulsarCollectionView',
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'defaults' }
PulsarContextStackPresenter class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 1;
		yourself
]

{ #category : 'layout' }
PulsarContextStackPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: listPresenter;
		yourself
]

{ #category : 'private' }
PulsarContextStackPresenter >> findFirstRelevantStackIndex [
	| counter |
	
	counter := 1.
	listPresenter items do: [ :contextModel | 
		contextModel methodClass == TestAsserter 
			ifFalse: [ ^ counter ].
		counter := counter + 1 ].
	
	^ 1
]

{ #category : 'initialization' }
PulsarContextStackPresenter >> initializePresenters [

	self addStyle: 'pulsarDebugger'.

	listPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'pulsarContextStackList';
		display: [ :aModel | aModel name ];
		yourself
]

{ #category : 'initialization' }
PulsarContextStackPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Stack';
		windowIcon: (self iconNamed: self panelPlacedIconName)
]

{ #category : 'private' }
PulsarContextStackPresenter >> panelPlaced: aPanelWidgetPresenter [

	logger trace.
	self maybeActivateIconOnPanel: aPanelWidgetPresenter
]

{ #category : 'private' }
PulsarContextStackPresenter >> panelPlacedIconName [

	^ 'stack'
]

{ #category : 'accessing' }
PulsarContextStackPresenter >> panelPosition [

	^ self class defaultPanelPosition
]

{ #category : 'api - selection' }
PulsarContextStackPresenter >> selectFirst [ 

	listPresenter selectFirst
]

{ #category : 'api - selection' }
PulsarContextStackPresenter >> selectFirstRelevantStackIndex [
	
	listPresenter 
		selectIndex: self findFirstRelevantStackIndex 
		scrollToSelection: true
]

{ #category : 'accessing' }
PulsarContextStackPresenter >> selectedContextModel [

	^ listPresenter selectedItem
]

{ #category : 'initialization' }
PulsarContextStackPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [
		listPresenter items: self model stack.
		self selectFirstRelevantStackIndex ]
]
