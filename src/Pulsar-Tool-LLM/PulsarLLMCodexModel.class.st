"
I am the concrete Pulsar LLM model that drives the Codex CLI against the running image, despite my class name; my label is 'Codex'.

My responsibility is session setup and lifecycle. On #prepare I inherit the AGENTS.md and skill setup, then ensure a .codex/config.toml declaring the local Pharo MCP server. On #connectTo: the inherited flow starts that server, and I spawn codex in the supplied terminal presenter, exposing Pharo tools to the agent. On #disconnect the server is stopped and the session marked ended.

I collaborate with PulsarLLMModel for the shared protocol and MCP state, with MCP for the tool server, and with the Codex executable and terminal presenter. Configuration files are written only when missing.
"
Class {
	#name : 'PulsarLLMCodexModel',
	#superclass : 'PulsarLLMModel',
	#category : 'Pulsar-Tool-LLM-Model',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarLLMCodexModel class >> configDefinition [
	<pulsarSourceEditor: 'toml'>

	^ '
[mcp_servers.pharo]
enabled = true
required = true
url = "http://127.0.0.1:4000"

[mcp_servers.pharo.tools.evaluate]
approval_mode = "approve"

[mcp_servers.pharo.tools.inspect-class]
approval_mode = "approve"

[mcp_servers.pharo.tools.inspect-method]
approval_mode = "approve"

[mcp_servers.pharo.tools.find-packages]
approval_mode = "approve"

[mcp_servers.pharo.tools.find-classes]
approval_mode = "approve"

[mcp_servers.pharo.tools.find-methods]
approval_mode = "approve"

[mcp_servers.pharo.tools.find-repositories]
approval_mode = "approve"

[mcp_servers.pharo.tools.edit-repository]
approval_mode = "approve"

[mcp_servers.pharo.tools.edit-method]
approval_mode = "approve"

[mcp_servers.pharo.tools.run-tests]
approval_mode = "approve"

[mcp_servers.pharo.tools.pulsar-debugger]
approval_mode = "approve"

[mcp_servers.pharo.tools.validate-code]
approval_mode = "approve"
'
]

{ #category : 'accessing' }
PulsarLLMCodexModel class >> label [

	^ 'Codex'
]

{ #category : 'private' }
PulsarLLMCodexModel >> ensureConfig [
	| dir ref |

	dir := FileLocator imageDirectory / '.codex'.
	(dir exists and: [ dir isDirectory not ])
		ifTrue: [ dir ensureDelete ].
	dir ensureCreateDirectory.

	ref := dir / 'config.toml'.
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << self class configDefinition ] ]
]

{ #category : 'private' }
PulsarLLMCodexModel >> performConnectTo: aTerminalPresenter withPrompt: aString [
	| command |
	
	command := PulsarWhich pathOfProgram: 'codex'.
	command ifEmpty: [ 
		self error: 'Codex not found. Please install it and make sure it can be found in the PATH.' ].

	self 
		spawnFromHost: command 
		arguments: (aString ifNotNil: [ { self ensurePromptCompliance: aString } ] ifNil: [ #() ])
		in: aTerminalPresenter
]

{ #category : 'actions' }
PulsarLLMCodexModel >> prepare [

	super prepare.
	self ensureConfig
]
