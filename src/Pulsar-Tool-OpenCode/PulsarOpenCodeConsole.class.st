Class {
	#name : 'PulsarOpenCodeConsole',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTSnapshot',
	#classTraits : 'PulsarTSnapshot classTrait',
	#instVars : [
		'toolbarPresenter',
		'terminalPresenter',
		'mcp',
		'connected',
		'toggleConnectButtonPresenter'
	],
	#category : 'Pulsar-Tool-OpenCode',
	#package : 'Pulsar-Tool-OpenCode'
}

{ #category : 'private' }
PulsarOpenCodeConsole class >> agentsDefinition [

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
PulsarOpenCodeConsole class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
		column: 2;
		yourself
]

{ #category : 'accessing' }
PulsarOpenCodeConsole class >> defaultTitle [

	^ 'Playground'
]

{ #category : 'private' }
PulsarOpenCodeConsole class >> mcpPort [

	^ 4000
]

{ #category : 'layout' }
PulsarOpenCodeConsole >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: terminalPresenter;
		yourself
]

{ #category : 'actions' }
PulsarOpenCodeConsole >> doClose [

	self ensureDisconnect.
	self withNearWindowLikeDo: [ :aWindow | aWindow close ]	
]

{ #category : 'actions' }
PulsarOpenCodeConsole >> doConnect [

	self isConnected ifTrue: [ ^ self ].
	
[ 
		self ensureAgent.
		self ensureMCP.
		self ensureConnect.
		
		connected := true.
		"if will trigger a status, but the connected flag will prevent a re-execution" 
		self updateStatus.
	]
	on: Error 
	do: [ :e | terminalPresenter feedLine: 'Error: ', e messageText ]
]

{ #category : 'actions' }
PulsarOpenCodeConsole >> doDisconnect [

	self isConnected ifFalse: [ ^ self ].
	
	self ensureDisconnect.
	connected := false.
	"if will trigger a status, but the connected flag will prevent a re-execution" 
	self updateStatus

]

{ #category : 'private' }
PulsarOpenCodeConsole >> ensureAgent [
	| reference |

	reference := FileLocator imageDirectory / 'AGENTS.md'.
	reference exists ifTrue: [
		logger debug: 'AGENTS.md exists, skipping'.
		^ self ].
		
	reference writeStreamDo: [ :stream | 
		stream << self class agentsDefinition ]
]

{ #category : 'private' }
PulsarOpenCodeConsole >> ensureConnect [
	| command |
	
	self flag: #TODO. "Make this more robust"
	command := (LibC resultOfCommand: 'which opencode').
	command ifEmpty: [
		self error: 'OpenCode not found. Please install it and make sure it can be found in the PATH.' ].

	terminalPresenter
		spawnAsync: command trimBoth 
		workingDirectory: FileLocator imageDirectory fullName
		arguments: #()
]

{ #category : 'private' }
PulsarOpenCodeConsole >> ensureDisconnect [

	(mcp isNotNil and: [ mcp isRunning ]) 
		ifTrue: [ mcp stop ]
]

{ #category : 'private' }
PulsarOpenCodeConsole >> ensureMCP [

	(mcp isNotNil and: [ mcp isRunning ]) ifTrue: [ ^ self ].
	
	mcp := MCP new.
	mcp server port: self class mcpPort.
	mcp start
]

{ #category : 'initialization' }
PulsarOpenCodeConsole >> initialize [

	connected := false.
	super initialize
]

{ #category : 'initialization' }
PulsarOpenCodeConsole >> initializePresenters [

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
PulsarOpenCodeConsole >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class defaultTitle;
		windowIcon: (self iconNamed: self panelPlacedIconName);
		whenOpenedDo: [ 
			self scheduleJob: [ self doConnect ] ]
]

{ #category : 'testing' }
PulsarOpenCodeConsole >> isConnected [

	^ connected
]

{ #category : 'private' }
PulsarOpenCodeConsole >> panelPlacedIconName [

	^ 'chat'
]

{ #category : 'private - actions' }
PulsarOpenCodeConsole >> toggleConnection: aState [

	aState 
		ifTrue: [ self doConnect ]
		ifFalse: [ self doDisconnect ]
]

{ #category : 'initialization' }
PulsarOpenCodeConsole >> updatePresenter [ 

	super updatePresenter. 
	
	self updateTitle.
	self updateStatus
]

{ #category : 'initialization' }
PulsarOpenCodeConsole >> updateStatus [

	toggleConnectButtonPresenter state: self isConnected
]

{ #category : 'initialization' }
PulsarOpenCodeConsole >> updateTitle [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		aBreadcrumb addSegment: self class defaultTitle ]
]
