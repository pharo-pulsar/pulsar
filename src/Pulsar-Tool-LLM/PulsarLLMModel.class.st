"
I am the abstract base class for LLM integration models in Pulsar.

I define the common protocol for preparing an LLM environment, connecting to it, and disconnecting. Subclasses must implement #prepare, #connectTo:, and #disconnect.

I hold the shared MCP server instance (mcp) that exposes Pharo tools to the LLM, and a connected flag tracking whether a session is active.

I provide reusable utilities for subclasses: #startMCP / #stopMCP to control the MCP server lifecycle, and #ensureAgent to write the AGENTS.md guidance file into the image directory.
"
Class {
	#name : 'PulsarLLMModel',
	#superclass : 'Object',
	#instVars : [
		'mcp',
		'connected'
	],
	#category : 'Pulsar-Tool-LLM',
	#package : 'Pulsar-Tool-LLM'
}

{ #category : 'accessing' }
PulsarLLMModel class >> agentsDefinition [

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

{ #category : 'accessing' }
PulsarLLMModel class >> mcpPort [

	^ 4000
]

{ #category : 'actions' }
PulsarLLMModel >> connectTo: aTerminalPresenter [

	self subclassResponsibility
]

{ #category : 'private' }
PulsarLLMModel >> connected: anObject [

	connected := anObject
]

{ #category : 'actions' }
PulsarLLMModel >> disconnect [

	self subclassResponsibility
]

{ #category : 'private' }
PulsarLLMModel >> ensureAgent [
	| ref |
	
	ref := FileLocator imageDirectory / 'AGENTS.md'.
	ref exists ifFalse: [ 
		ref writeStreamDo: [ :stream | stream << self class agentsDefinition ] ]
]

{ #category : 'initialization' }
PulsarLLMModel >> initialize [

	connected := false.
	super initialize
]

{ #category : 'accessing' }
PulsarLLMModel >> isConnected [

	^ connected
]

{ #category : 'accessing' }
PulsarLLMModel >> name [
	
	^ self subclassResponsibility
]

{ #category : 'actions' }
PulsarLLMModel >> prepare [

	self subclassResponsibility
]

{ #category : 'private' }
PulsarLLMModel >> startMCP [

	(mcp isNotNil and: [ mcp isRunning ]) ifTrue: [ ^ self ].

	mcp := MCP new.
	mcp server port: self class mcpPort.
	mcp start
]

{ #category : 'private' }
PulsarLLMModel >> stopMCP [

	(mcp isNotNil and: [ mcp isRunning ]) 
		ifTrue: [ mcp stop ]
]
