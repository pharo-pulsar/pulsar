"
I am the concrete `PulsarLLMModel` that runs the `pi` coding agent as a Pulsar LLM terminal client.

I supply the `pi`-specific half of a session; the shared Pharo MCP server, the `AGENTS.md` guidance, skill installation, the connection flag, and the connect/disconnect lifecycle come from `PulsarLLMModel`.

On `#prepare` I add the configuration `pi` needs: a `.pi` directory next to the image holding an `mcp-adapter.json` that declares the Pharo MCP server and enables direct tool access. It is written only when missing, so a local adaptation survives. On connect the inherited flow starts the MCP server and I resolve `pi` through `PulsarWhich`, raising an error that names the `PATH` requirement when the executable is absent, then spawn it in the caller's terminal presenter with the image directory as working directory - which is what makes the local configuration apply. An optional initial prompt travels as a command-line argument, normalized by `ensurePromptCompliance:` to end with a newline so the client submits it.

I hold no state of my own, and `#isAvailable` answers true unconditionally, so a missing executable surfaces only when a session is attempted. An LLM terminal (`PulsarLLMChatConsole`) takes its client class from the application's `agentName` setting through `PulsarLLMModel class>>findAgentNamed:`, which matches my label `Pi`; the same flow can be driven directly:

```
PulsarLLMPiModel new
    connectTo: aTerminalPresenter
```

`PulsarLLMOpenCodeModel`, `PulsarLLMClaudeModel` and `PulsarLLMCodexModel` are peers of the same shape for other clients.
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
	<pulsarSourceEditor: 'json'>

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
	ref := dir / 'mcp-adapter.json'. 
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << self class configDefinition ] ]
]

{ #category : 'actions' }
PulsarLLMPiModel >> ensureEnvironment [

	"OSEnvironment current 
		at: #EDITOR put: 'micro'"
]

{ #category : 'private' }
PulsarLLMPiModel >> performConnectTo: aTerminalPresenter withPrompt: aString [
	| command |
	
	command := PulsarWhich pathOfProgram:  'pi'.
	command ifEmpty: [ 
		self error: 'Pi not found. Please install it and make sure it can be found in the PATH.' ].

	self 
		spawn: 'pi'
		arguments: (aString ifNotNil: [ self ensurePromptCompliance: aString ] ifNil: [ #() ])
		in: aTerminalPresenter
]

{ #category : 'actions' }
PulsarLLMPiModel >> prepare [

	super prepare.
	self ensureEnvironment.
	self ensureConfig.
]
