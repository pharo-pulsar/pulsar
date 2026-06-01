"
I am the concrete model for integrating with the OpenCode CLI tool.

On #prepare I ensure configuration files exist: AGENTS.md (Pharo MCP guidance for the LLM) and opencode.json (MCP server URL for the OpenCode client).

On #connectTo: I start the Pharo MCP server and spawn the opencode CLI in the given terminal presenter, connecting the LLM to the running image.

On #disconnect I stop the MCP server and mark the session as ended.
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
PulsarLLMCodexModel >> performConnectTo: aTerminalPresenter [
	| command |
	
	command := PulsarWhich pathOfProgram: 'codex'.
	command ifEmpty: [ 
		self error: 'Codex not found. Please install it and make sure it can be found in the PATH.' ].

	aTerminalPresenter 
		spawnAsync: command trimBoth 
		workingDirectory: FileLocator imageDirectory fullName 
		arguments: #().

]

{ #category : 'actions' }
PulsarLLMCodexModel >> prepare [

	super prepare.
	self ensureConfig
]
