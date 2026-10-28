"
I am the concrete model for integrating with the OpenCode CLI tool.

On #prepare I ensure configuration files exist: AGENTS.md (Pharo MCP guidance for the LLM) and opencode.json (MCP server URL for the OpenCode client).

On #connectTo: I start the Pharo MCP server and spawn the opencode CLI in the given terminal presenter, connecting the LLM to the running image.

On #disconnect I stop the MCP server and mark the session as ended.
"
Class {
	#name : 'PulsarLLMOpenCodeModel',
	#superclass : 'PulsarLLMModel',
	#category : 'Pulsar-Tool-LLM-Model',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Model'
}

{ #category : 'api' }
PulsarLLMOpenCodeModel class >> apiClass [

	^ PulsarLLMOpenCodeAPI
]

{ #category : 'accessing' }
PulsarLLMOpenCodeModel class >> configDefinition [
	<pulsarSourceEditor: 'json'>

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

{ #category : 'accessing' }
PulsarLLMOpenCodeModel class >> label [

	^ 'OpenCode'
]

{ #category : 'private' }
PulsarLLMOpenCodeModel >> ensureConfig [
	| ref |

	ref := FileLocator imageDirectory / 'opencode.json'.
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << self class configDefinition ] ]
]

{ #category : 'private' }
PulsarLLMOpenCodeModel >> ensureEnvironment [

	OSEnvironment current 
		at: #OPENCODE_ENABLE_EXA ifAbsentPut: [ 'true' ];
		at: #OPENCODE_SERVER_PASSWORD put: UUID new asString
]

{ #category : 'private' }
PulsarLLMOpenCodeModel >> ensureExa [

	OSEnvironment current 
		at: #OPENCODE_ENABLE_EXA ifAbsentPut: [ 'true' ];
		at: #OPENCODE_SERVER_PASSWORD put: UUID new asString
]

{ #category : 'private' }
PulsarLLMOpenCodeModel >> performConnectTo: aTerminalPresenter withPrompt: aString [
	| command |
	
	command := PulsarWhich pathOfProgram: 'opencode'.
	command ifEmpty: [ 
		self error: 'OpenCode not found. Please install it and make sure it can be found in the PATH.' ].

	self 
		spawnFromHost: command 
		arguments: (aString 
			ifNotNil: [ { '--standalone'. '--prompt'. self ensurePromptCompliance: aString } ]
			ifNil: [ #('--standalone') ])
		in: aTerminalPresenter
]

{ #category : 'actions' }
PulsarLLMOpenCodeModel >> prepare [

	super prepare.
	self ensureConfig.
	self ensureEnvironment
]

{ #category : 'private' }
PulsarLLMOpenCodeModel >> skillBaseDirectory [

	^ '.opencode'
]
