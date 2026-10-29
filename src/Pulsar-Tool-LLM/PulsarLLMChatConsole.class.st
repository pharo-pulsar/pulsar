"
I am a Pulsar terminal panel for an LLM client.

Each panel owns one VTE terminal and one client process. The client class is captured from the global LLM setting when the panel is created, so changing the setting only affects new terminals. Multiple panels can coexist, each with its own conversation and process, while all of them share the single MCP server exposed by PulsarLLMSharedMCPServer.

I am opened from the New LLM terminal browser action or from an agent menu item. Agent menu items carry an initial prompt; I send it to the client once the terminal starts. Closing me terminates my client process and releases my MCP reference. Snapshot restoration keeps the panel title and client but does not reconnect or resend prompts.

The client TUI owns client-specific controls such as thinking display.
"
Class {
	#name : 'PulsarLLMChatConsole',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTSnapshot + PulsarTControlUpdate',
	#classTraits : 'PulsarTSnapshot classTrait + PulsarTControlUpdate classTrait',
	#instVars : [
		'toolbarPresenter',
		'terminalPresenter',
		'clientModel',
		'updating',
		'terminationRequested'
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

{ #category : 'accessing' }
PulsarLLMChatConsole >> clientModel [

	^ clientModel
]

{ #category : 'accessing' }
PulsarLLMChatConsole >> clientModel: aModel [

	clientModel := aModel
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> connectPresenters [

	terminalPresenter whenChildExitedDo: [ :ann |
			| exitStatus |
			exitStatus := ann exitStatus.
			logger debug: f'Terminal exit: [exitStatus description]'.
			(exitStatus isSuccess 
				or: [ terminationRequested 
				or: [ exitStatus isInterrupted ] ]) 
				ifFalse: [
					self notificationCenter warning: (Warning new
						messageText: f'Terminal [exitStatus description]';
						yourself) ].
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

{ #category : 'private' }
PulsarLLMChatConsole >> doConnect [

	self isConnected ifTrue: [ ^ self ].
	terminationRequested := false.

	[
		self updatingWhile: [
			self model
					clientClass: self usingLLM;
					connectTo: terminalPresenter.
				self updateTitle.
				self updateStatus ] ]
	on: Error
	do: [ :e |
		terminalPresenter terminateAllSpawns.
		self notificationCenter error: e ]
]

{ #category : 'private' }
PulsarLLMChatConsole >> doDisconnect [

	terminationRequested := true.
	self clientModel ifNotNil: [ :aModel | aModel disconnect ].
	self clientModel: nil.
	terminalPresenter ifNotNil: [ :aPresenter | aPresenter terminateAllSpawns ].
	self updatingWhile: [ self updateStatus ]
]

{ #category : 'private' }
PulsarLLMChatConsole >> doDisconnectClosing: aBoolean [

	[ 
		self doDisconnect.
		aBoolean ifTrue: [ 
			self withNearWindowLikeDo: [ :aWindow | aWindow close ] ] 
	] 
	on: Error 
	do: [ :e | 
		self notificationCenter error: e ]
]

{ #category : 'actions' }
PulsarLLMChatConsole >> doNewTerminal [

	self notificationCenter announce: PulsarRequestNewLLMTerminal new
]

{ #category : 'events' }
PulsarLLMChatConsole >> eventRequestNewTerminal: ann [
	"Handles a new-terminal request by feeding its initial prompt into this
	console's existing terminal rather than opening another one. The prompt
	comes from the announcement's model, and empty or nil prompts are
	ignored."
	| prompt |
	 
	prompt := ann model initialPrompt.
	prompt isEmptyOrNil ifTrue: [ ^ self ].

	terminalPresenter feedChildMultipleLine: prompt withPlatformLineEndings
]

{ #category : 'events' }
PulsarLLMChatConsole >> eventThemeChanged: ann [
	super eventThemeChanged: ann.
	ann isDark
		ifTrue: [ terminalPresenter beDarkTheme ]
		ifFalse: [ terminalPresenter beLightTheme ]
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> initialize [

	model ifNil: [
		self setModelBeforeInitialization: PulsarLLMChatConsoleModel new ].
	super initialize
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> initializePresenters [

	self addStyle: 'pulsarChatConsole'.

	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.

	toolbarPresenter
		addPresenter: (self newToolbar
			beIcons;
			add: (self newButton
				addStyle: 'flat';
				icon: (self iconNamed: 'add');
				help: 'New LLM terminal';
				action: [ self doNewTerminal ];
				yourself);
			add: (self newButton
				addStyle: 'flat';
				icon: (self iconNamed: 'close');
				help: 'Close terminal';
				action: [ self doClose ];
				yourself);
			yourself).

	terminalPresenter := self instantiate: VteTerminalPresenter.
	terminalPresenter addStyle: 'terminal'
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self model title;
		windowIcon: (self iconNamed: self panelPlacedIconName);
		whenOpenedDo: [ self model autoConnect ifTrue: [ self scheduleJob: [ self doConnect ] ] ]
]

{ #category : 'testing' }
PulsarLLMChatConsole >> isConnected [

	^ self clientModel notNil and: [ self clientModel isConnected ]
]

{ #category : 'private' }
PulsarLLMChatConsole >> panelPlacedIconName [

	^ "'chat'" 'agent'
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> registerToEvents [

	super registerToEvents.
	self announcer
		when: PulsarRequestNewLLMTerminal 
		send: #eventRequestNewTerminal: 
		to: self	
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
	self updatingWhile: [ self updateStatus ]
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> updateStatus [
	
]

{ #category : 'initialization' }
PulsarLLMChatConsole >> updateTitle [

	toolbarPresenter title: self model title
]

{ #category : 'private' }
PulsarLLMChatConsole >> usingLLM [

	^ PulsarLLMModel findAgentNamed: self application settings agentName
]
