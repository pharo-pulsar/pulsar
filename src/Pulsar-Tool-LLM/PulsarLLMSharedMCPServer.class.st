"
I provide the single MCP server used by Pulsar LLM terminals.

Every terminal acquires me when it connects and releases me when it disconnects. If an MCP server is already running, I reuse it and never stop it. If no server is running, I start one and become its owner; I stop it when the last terminal releases it. Sharing the server lets several client processes use the same Pharo tools without competing for port 4000.
"
Class {
	#name : 'PulsarLLMSharedMCPServer',
	#superclass : 'Object',
	#instVars : [
		'mcp'
	],
	#classVars : [
		'Default'
	],
	#category : 'Pulsar-Tool-LLM-Model',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarLLMSharedMCPServer class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : 'class initialization' }
PulsarLLMSharedMCPServer class >> reset [

	Default ifNotNil: [ :server | server stop ].
	Default := nil
]

{ #category : 'private' }
PulsarLLMSharedMCPServer >> ensureStarted [

	self isRunning ifTrue: [ ^ self ].
	
	mcp := MCP new.
	mcp server
		loggingOff;
		port: PulsarLLMModel mcpPort.
	mcp start
]

{ #category : 'testing' }
PulsarLLMSharedMCPServer >> isRunning [

	^ mcp isNotNil 
		and: [ 
			[ mcp isRunning ]
			on: Error 
			do: [ :e | false ] ]
]

{ #category : 'accessing' }
PulsarLLMSharedMCPServer >> mcp [

	^ mcp
]

{ #category : 'accessing' }
PulsarLLMSharedMCPServer >> stop [

	self isRunning ifTrue: [ mcp stop ].
	mcp := nil
]
