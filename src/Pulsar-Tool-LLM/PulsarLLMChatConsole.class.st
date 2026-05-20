Class {
	#name : 'PulsarLLMChatConsole',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTSnapshot',
	#classTraits : 'PulsarTSnapshot classTrait',
	#instVars : [
		'toolbarPresenter',
		'terminalPresenter',
		'toggleConnectButtonPresenter'
	],
	#category : 'Pulsar-Tool-LLM',
	#package : 'Pulsar-Tool-LLM'
}

{ #category : 'private' }
PulsarLLMChatConsole class >> agentsDefinition [

	^ '# Pharo MCP Guidance

Use the `pharo` MCP server for Pharo and Smalltalk tasks in this workspace.

When a request involves Pharo, prefer MCP tool calls over guessing from memory or inspecting unrelated local files.

Use the `pharo` MCP tools first for:

- counting or listing packages
- browsing classes, methods, and protocols
- reading Pharo-side state that only exists in the running image
- triggering Pharo-side actions that the MCP server already exposes

If a needed answer should come from Pharo, explicitly say you are using the `pharo` MCP server.

If a `pharo` MCP tool fails or returns incomplete data, report the failure clearly instead of inventing the answer.

## How to use me

Remember that the Pharo image must be save when we finish to implement some code or execute heavy script.'
]

{ #category : 'defaults' }
PulsarLLMChatConsole class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
]

{ #category : 'accessing' }
PulsarLLMChatConsole class >> defaultTitle [

	^ 'Chat'
]

{ #category : 'private' }
PulsarLLMChatConsole class >> mcpPort [

	^ 4000
]

{ #category : 'private' }
PulsarLLMChatConsole class >> opencodeJsonDefinition [

	^ '{
  "mcp": {
    "pharo": {
      "type": "remote",
      "url": "http://127.0.0.1:4000",
      "enabled": true
    }
  }
}
'
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

	self doDisconnect.
	self withNearWindowLikeDo: [ :aWindow | aWindow close ]	
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

{ #category : 'initialization' }
PulsarLLMChatConsole >> initialize [

	self setModelBeforeInitialization: PulsarLLMOpenCodeModel new.
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

	toolbarPresenter 
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
	
	terminalPresenter := self instantiate: VteTerminalPresenter.
	terminalPresenter whenChildExitedDo: [ :ann |
		logger debug: 'Exit with code: ', ann status asString.
		self doClose ].

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
PulsarLLMChatConsole >> toggleConnection: aState [

	aState 
		ifTrue: [ self doConnect ]
		ifFalse: [ self doDisconnect ]
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> updatePresenter [ 

	super updatePresenter. 
	
	self updateTitle.
	self updateStatus
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
