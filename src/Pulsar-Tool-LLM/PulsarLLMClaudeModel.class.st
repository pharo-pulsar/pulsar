"
I am the concrete `PulsarLLMModel` that integrates the Claude Code command-line client into Pulsar.

I prepare the environment in which Claude can work against the running Pharo image: I register the Pharo MCP server on port 4000 with the Claude client and install the local permission and skill configuration it expects, including the shared AGENTS.md guidance provided by my superclass. Connecting starts that MCP server and launches Claude in the terminal presenter supplied by the caller; disconnecting stops the server and ends the session. Claude must be installed and available on the PATH.

I add no state of my own: the MCP server instance and the connection flag are inherited from PulsarLLMModel. I am discovered with the other available models through `PulsarLLMModel class>>allModels` and offered in the model selector of `PulsarLLMChatConsole`.

```
PulsarLLMClaudeModel new
    connectTo: aTerminalPresenter
```
"
Class {
	#name : 'PulsarLLMClaudeModel',
	#superclass : 'PulsarLLMModel',
	#category : 'Pulsar-Tool-LLM-Model',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Model'
}

{ #category : 'api' }
PulsarLLMClaudeModel class >> apiClass [

	^ PulsarLLMClaudeAPI
]

{ #category : 'accessing' }
PulsarLLMClaudeModel class >> configDefinition [

	<pulsarSourceEditor: 'json'>
	^ '{
  "mcpServers": {
    "pharo": {
		"type": "http",		
      	"url": "http://127.0.0.1:4000"
	}
  }
}
'
]

{ #category : 'api' }
PulsarLLMClaudeModel class >> configureAPI: anAPI forApplication: anApplication [

	anApplication ifNil: [ ^ self ].
	(anApplication respondsTo: #settings) ifFalse: [ ^ self ].
	anAPI thinking: anApplication settings thinking
]

{ #category : 'accessing' }
PulsarLLMClaudeModel class >> label [

	^ 'Claude'
]

{ #category : 'accessing' }
PulsarLLMClaudeModel class >> settingsDefinition [
	<pulsarSourceEditor: 'json'>
	
	^ '{
  "permissions": {
    "allow": [
      "mcp__pharo"
    ]
  },
  "enabledMcpjsonServers": [
    "pharo"
  ],
  "enableAllProjectMcpServers": true
}'
]

{ #category : 'private' }
PulsarLLMClaudeModel >> ensureConfig [
	| dir ref |

	dir := FileLocator imageDirectory.
	ref := dir / '.mcp.json'.
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << self class configDefinition ] ].
		
		
	dir := dir / self skillBaseDirectory.
	ref := dir / 'settings.local.json'.
	ref exists ifFalse: [
		ref writeStreamDo: [ :stream | stream << self class settingsDefinition ] ]
]

{ #category : 'actions' }
PulsarLLMClaudeModel >> ensureEnvironment [

	OSEnvironment current 
		at: #TERM ifAbsentPut: [ 'xterm-256color' ]
]

{ #category : 'testing' }
PulsarLLMClaudeModel >> hasThinkingToggle [

	^ true
]

{ #category : 'private' }
PulsarLLMClaudeModel >> performConnectTo: aTerminalPresenter [
	| command |
	
	command := PulsarWhich pathOfProgram: 'claude'.
	command ifEmpty: [ 
		self error: 'Claude not found. Please install it and make sure it can be found in the PATH.' ].

	self 
		spawnFromHost: command trimBoth
		arguments: #()
		in: aTerminalPresenter
]

{ #category : 'actions' }
PulsarLLMClaudeModel >> prepare [

	super prepare.
	self ensureConfig.
	self ensureEnvironment
]

{ #category : 'private' }
PulsarLLMClaudeModel >> skillBaseDirectory [

	^ '.claude'
]
