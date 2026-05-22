Class {
	#name : 'PulsarLLMChatConsole',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTSnapshot + PulsarTControlUpdate',
	#classTraits : 'PulsarTSnapshot classTrait + PulsarTControlUpdate classTrait',
	#instVars : [
		'toolbarPresenter',
		'terminalPresenter',
		'toggleConnectButtonPresenter',
		'modelSelectorPresenter'
	],
	#classVars : [
		'LLMModelClass'
	],
	#category : 'Pulsar-Tool-LLM',
	#package : 'Pulsar-Tool-LLM'
}

{ #category : 'defaults' }
PulsarLLMChatConsole class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
]

{ #category : 'accessing' }
PulsarLLMChatConsole class >> defaultTitle [

	^ 'Chat'
]

{ #category : 'accessing' }
PulsarLLMChatConsole class >> usingLLM [

	^ LLMModelClass ifNil: [ PulsarLLMOpenCodeModel ]
]

{ #category : 'accessing' }
PulsarLLMChatConsole class >> usingLLM: aLLMModelClass [

	LLMModelClass := aLLMModelClass
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> connectPresenters [

	modelSelectorPresenter whenSelectedItemChangedDo: [ :selectedClass |
		self switchLLMModel: selectedClass ].
		
	terminalPresenter whenChildExitedDo: [ :ann |
		logger debug: 'Exit with code: ' , ann status asString.
		self doDisconnectClosing: false ]
]

{ #category : 'layout' }
PulsarLLMChatConsole >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: terminalPresenter;
		yourself
]

{ #category : 'actions' }
PulsarLLMChatConsole >> doClose [

	self doDisconnectClosing: true
]

{ #category : 'actions' }
PulsarLLMChatConsole >> doConnect [

	self isConnected ifTrue: [ ^ self ].
	
	[ 
		self model 
			prepare;
			"connecting will trigger a status change, but the connected flag 
		 	will prevent a re-execution" 
			connectTo: terminalPresenter.
	
		self updateStatus.
	]
	on: Error 
	do: [ :e | terminalPresenter feedLine: 'Error: ', e messageText ]
]

{ #category : 'actions' }
PulsarLLMChatConsole >> doDisconnect [

	self isConnected ifFalse: [ ^ self ].
	
	terminalPresenter terminateAllSpawns.
	self model disconnect.
	"disconnecting will also trigger a status change, but the connected flag 
	 will prevent a re-execution" 
	self updateStatus
]

{ #category : 'actions' }
PulsarLLMChatConsole >> doDisconnectClosing: aBoolean [

	self doDisconnect.
	aBoolean ifTrue: [ 
		self withNearWindowLikeDo: [ :aWindow | 
			aWindow close ] ]
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> initialize [

	self setModelBeforeInitialization: self class usingLLM new.
	super initialize
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> initializePresenters [

	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.

	(toggleConnectButtonPresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: 'chat-connect');
		help: 'Toggle chat connect';
		state: self isConnected;
		whenChangedDo: [ :state | self toggleConnection: state ];
		yourself.

	modelSelectorPresenter := self newDropDown
		addStyle: 'flat';
		display: [ :each | each label ];
		yourself.

	toolbarPresenter
		addPresenter: (self newPresenter 
			layout: (SpBoxLayout newVertical 
				vAlignCenter;
				add: modelSelectorPresenter;
				yourself);
			yourself);
		addPresenter: (self newToolbar
			displayMode: self application toolbarDisplayMode;
			add: toggleConnectButtonPresenter;
			yourself);
		addPresenter: (self newToolbar
			beIcons;
			add: (self newButton
				addStyle: 'flat';
				icon: (self iconNamed: 'close');
				help: 'Close OpenCode';
				action: [ self doClose ];
				yourself);
			yourself).

	terminalPresenter := self instantiate: VteTerminalPresenter
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class defaultTitle;
		windowIcon: (self iconNamed: self panelPlacedIconName);
		whenOpenedDo: [ 
			self scheduleJob: [ self doConnect ] ]
]

{ #category : 'testing' }
PulsarLLMChatConsole >> isConnected [

	^ self model isConnected
]

{ #category : 'private' }
PulsarLLMChatConsole >> panelPlacedIconName [

	^ 'chat'
]

{ #category : 'private - actions' }
PulsarLLMChatConsole >> switchLLMModel: aModelClass [
	| wasConnected |
	
	self isUpdating ifTrue: [ ^ self ].
	aModelClass = self class usingLLM ifTrue: [ ^ self ].
	
	self scheduleJob: [
		self updatingWhile: [
			wasConnected := self isConnected.
			wasConnected ifTrue: [ self doDisconnectClosing: false ].
			self class usingLLM: aModelClass.
			self model: aModelClass new.
			wasConnected ifTrue: [ self doConnect ] ] ]
]

{ #category : 'private - actions' }
PulsarLLMChatConsole >> toggleConnection: aState [

	aState 
		ifTrue: [ self doConnect ]
		ifFalse: [ self doDisconnect ]
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> updatePresenter [ 

	self updateTitle.
	self updateStatus.
	
	modelSelectorPresenter 
		items: PulsarLLMModel allModels;
		selectItem: self class usingLLM.
	
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> updateStatus [

	toggleConnectButtonPresenter 
		help: ('Toggle chat connect (current: {1}CONNECTED)' format: { self isConnected 
			ifTrue: [ '' ] 
			ifFalse: [ 'DIS' ]});
		state: self isConnected not
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> updateTitle [

	toolbarPresenter title: ('{1}: {2}' format: { 
		self class defaultTitle. 
		self model name })
]
