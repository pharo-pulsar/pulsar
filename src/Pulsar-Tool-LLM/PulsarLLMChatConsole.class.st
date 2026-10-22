"
I am the panel where a programmer holds a live conversation with an LLM agent from inside Pulsar. I wrap a command-line agent session in an embedded terminal and surround it with the controls needed to start, stop, and retarget that session without leaving the IDE.

I own the presentation of a session, not its mechanics. A `PulsarLLMModel` subclass knows how to prepare its environment, connect to the terminal I supply, and disconnect; I choose the agent, reflect its connection state, and keep the toolbar in sync. The model selector lists the agents returned by `PulsarLLMModel class>>allModels`; changing it reconnects an active session to the new agent and remembers the choice through the application settings. Opening the window and toggling the connect control drive the same connection path, while closing the window disconnects.

The terminal is a `VteTerminalPresenter`, and the surrounding toolbar is a `PulsarEditorToolbarPresenter`. A thinking-output toggle is enabled for agents that support it and is persisted in the application settings. An `updating` flag guards programmatic toolbar changes so they do not re-enter the connection callbacks.

I am normally reached from the Pulsar browser dock action defined in `PulsarBrowser>>defineOpenCodeExtraActionsOn:`.

```
PulsarLLMChatConsole new open
```
"
Class {
	#name : 'PulsarLLMChatConsole',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTSnapshot + PulsarTControlUpdate',
	#classTraits : 'PulsarTSnapshot classTrait + PulsarTControlUpdate classTrait',
	#instVars : [
		'toolbarPresenter',
		'terminalPresenter',
		'toggleConnectButtonPresenter',
		'modelSelectorPresenter',
		'thinkingTogglePresenter',
		'updating'
	],
	#category : 'Pulsar-Tool-LLM-View',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'View'
}

{ #category : 'defaults' }
PulsarLLMChatConsole class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
		column: 2;
		yourself
]

{ #category : 'accessing' }
PulsarLLMChatConsole class >> defaultTitle [

	^ 'Assistant'
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> connectPresenters [

	"modelSelectorPresenter whenSelectedItemChangedDo: [ :selectedClass |
		self switchLLMModel: selectedClass ]."
		
	terminalPresenter whenChildExitedDo: [ :ann |
		logger debug: 'Exit with code: ' , ann status asString.
		self doDisconnectClosing: self isUpdating not ]
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
		self updatingWhile: [
			self model 
				prepare;
				"connecting will trigger a status change, but the connected flag 
			 	will prevent a re-execution" 
				connectTo: terminalPresenter.
		
			self updateStatus ].
	]
	on: Error 
	do: [ :e | terminalPresenter feedLine: 'Error: ', e messageText ]
]

{ #category : 'actions' }
PulsarLLMChatConsole >> doDisconnect [

	self isConnected ifFalse: [ ^ self ].
	
	self updatingWhile: [ 
		terminalPresenter terminateAllSpawns.
		self model disconnect.
		"disconnecting will also trigger a status change, but the connected flag 
		 will prevent a re-execution" 
		self updateStatus ]
]

{ #category : 'actions' }
PulsarLLMChatConsole >> doDisconnectClosing: aBoolean [

	self doDisconnect.
	aBoolean ifTrue: [ 
		self withNearWindowLikeDo: [ :aWindow | 
			aWindow close ] ]
]

{ #category : 'events' }
PulsarLLMChatConsole >> eventThemeChanged: ann [
	super eventThemeChanged: ann.
	ann isDark
		ifTrue: [ terminalPresenter beDarkTheme ]
		ifFalse: [ terminalPresenter beLightTheme ].

]

{ #category : 'initialization' }
PulsarLLMChatConsole >> initialize [

	self setModelBeforeInitialization: self usingLLM new.
	super initialize
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> initializePresenters [

	self addStyle: 'pulsarChatConsole'.

	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.

	(toggleConnectButtonPresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: 'chat-connect');
		help: 'Toggle MCP connect';
		state: self isConnected;
		whenChangedDo: [ :state | self toggleConnection: state ];
		yourself.

	"modelSelectorPresenter := self newDropDown
		                          addStyle: 'flat';
		                          display: [ :each | each label ];
		                          yourself."

	(thinkingTogglePresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: 'agent');
		help: 'Enable thinking output for new Claude agent sessions';
		state: self thinking;
		whenChangedDo: [ :state | self thinking: state ];
		yourself.

	toolbarPresenter
		"addPresenter: (self newPresenter
			layout: (SpBoxLayout newVertical
				vAlignCenter;
				add: modelSelectorPresenter;
				yourself);
			yourself);"
		addPresenter: (self newToolbar
			displayMode: self application toolbarDisplayMode;
			add: toggleConnectButtonPresenter;
			add: thinkingTogglePresenter;
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

	terminalPresenter := self instantiate: VteTerminalPresenter.
	terminalPresenter addStyle: 'terminal'
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

	^ "'chat'" 'agent'
]

{ #category : 'private - actions' }
PulsarLLMChatConsole >> switchLLMModel: aModelClass [

	| wasConnected |
	self isUpdating ifTrue: [ ^ self ].
	aModelClass ifNil: [ ^ self ].
	aModelClass = self model class ifTrue: [ ^ self ].

	self scheduleJob: [
			self updatingWhile: [
					wasConnected := self isConnected.
					wasConnected ifTrue: [ self doDisconnectClosing: false ].
					self usingLLM: aModelClass.
					self model: aModelClass new.
					wasConnected ifTrue: [ self doConnect ] ] ]
]

{ #category : 'accessing' }
PulsarLLMChatConsole >> thinking [

	^ self application settings thinking
]

{ #category : 'accessing' }
PulsarLLMChatConsole >> thinking: aBoolean [

	self application settings thinking: aBoolean
]

{ #category : 'private - actions' }
PulsarLLMChatConsole >> toggleConnection: aState [
	self isUpdating ifTrue: [ ^ self ].

	aState 
		ifTrue: [ self doConnect ]
		ifFalse: [ self doDisconnect ]
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> updatePresenter [

	self updateTitle.
	self updateStatus.

	"modelSelectorPresenter
		items: PulsarLLMModel allModels;
		selectItem: self model class."

	thinkingTogglePresenter
		state: self thinking;
		visible: self model hasThinkingToggle
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> updateStatus [

	toggleConnectButtonPresenter 
		help: ('Toggle MCP connect (current: {1}CONNECTED)' format: { self isConnected 
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

{ #category : 'private' }
PulsarLLMChatConsole >> usingLLM [

	^ PulsarLLMModel findAgentNamed: self application settings agentName
]

{ #category : 'accessing' }
PulsarLLMChatConsole >> usingLLM: aModelClass [

	self application settings agentName: aModelClass label
]
