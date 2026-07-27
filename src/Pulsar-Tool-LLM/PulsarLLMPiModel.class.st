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

{ #category : 'testing' }
PulsarLLMPiModel class >> isAvailable [

	self flag: #TODO. "not included for the moment because I need to add an MCP extension 
	and I do not have time/energy right now" 

	^ false
]

{ #category : 'accessing' }
PulsarLLMPiModel class >> label [

	^ 'Pi'
]

{ #category : 'private' }
PulsarLLMPiModel >> ensureConfig [
	"| ref |

	ref := FileLocator imageDirectory / 'opencode.json'.
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << self class configDefinition ] ]"
]

{ #category : 'private' }
PulsarLLMPiModel >> performConnectTo: aTerminalPresenter [
	| command |
	
	command := PulsarWhich pathOfProgram:  'pi'.
	command ifEmpty: [ 
		self error: 'Pi not found. Please install it and make sure it can be found in the PATH.' ].

	aTerminalPresenter 
		spawnAsync: command trimBoth 
		workingDirectory: FileLocator imageDirectory fullName 
		arguments: #()
]

{ #category : 'actions' }
PulsarLLMPiModel >> prepare [

	super prepare.
	self ensureConfig
]
