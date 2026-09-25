Class {
	#name : 'PulsarContextStackPresenter',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
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
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - definitions' }
PulsarContextStackPresenter >> defineStackActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #stack with: [ :group | group 
		priority: 100;
		name: 'Stack';
		beDisplayedAsGroup;	
		addActionWith: [ :action | action 
			priority: 110;
			name: 'Copy to clipboard';
			description: 'Copy stack to clipboard';
			iconName: 'copy-to-clipboard';
			action: [ self doCopyToClipboard ] ] ]
]

{ #category : 'private - actions' }
PulsarContextStackPresenter >> doCopyToClipboard [

	self model ifNil: [ ^ self ].
	self model doCopyToClipboardOn: self application.
	self withWindowDo: [ :w | w inform: 'Copied to clipboard' ]
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
	
	
	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #stack).	

	listPresenter := self newFilteringList
		addStyle: 'stList';
		addStyle: 'pulsarContextStackList';
		display: [ :aModel | aModel name ];
		enableSearch;
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
