"
I am the concrete model for integrating with the OpenCode CLI tool.

On #prepare I ensure configuration files exist: AGENTS.md (Pharo MCP guidance for the LLM) and opencode.json (MCP server URL for the OpenCode client).

On #connectTo: I start the Pharo MCP server and spawn the opencode CLI in the given terminal presenter, connecting the LLM to the running image.

On #disconnect I stop the MCP server and mark the session as ended.
"
Class {
	#name : 'PulsarLLMPiModel',
	#superclass : 'PulsarLLMModel',
	#category : 'Pulsar-Tool-LLM-Model',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarLLMPiModel class >> configDefinition [
	<pulsarFileEditor: 'json'>

	^ '{
  "mcpServers": {
    "pharo": {
      "url": "http://127.0.0.1:4000",
      "directTools": true
    }
  }
}'
]

{ #category : 'testing' }
PulsarLLMPiModel class >> isAvailable [

	^ true
]

{ #category : 'accessing' }
PulsarLLMPiModel class >> label [

	^ 'Pi'
]

{ #category : 'private' }
PulsarLLMPiModel >> ensureConfig [
	| dir ref |

	dir := (FileLocator imageDirectory / '.pi') ensureCreateDirectory.
	ref := dir / 'mcp.json'. 
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << self class configDefinition ] ]
]

{ #category : 'actions' }
PulsarLLMPiModel >> ensureEnvironment [

	"OSEnvironment current 
		at: #EDITOR put: 'micro'"
]

{ #category : 'private' }
PulsarLLMPiModel >> performConnectTo: aTerminalPresenter [
	| command |
	
	command := PulsarWhich pathOfProgram:  'pi'.
	command ifEmpty: [ 
		self error: 'Pi not found. Please install it and make sure it can be found in the PATH.' ].

	self spawn: command arguments: #() in: aTerminalPresenter
]

{ #category : 'actions' }
PulsarLLMPiModel >> prepare [

	super prepare.
	self ensureEnvironment.
	self ensureConfig.
]
