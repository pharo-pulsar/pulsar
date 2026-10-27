"
I am the abstract base for MCP tools that interact with the running Pulsar IDE.

`MCPTool` defines a tool's public metadata and execution mechanics. I add the Pulsar-specific half: I am how my subclasses reach the running `PulsarApplication`, from which they obtain IDE state such as open browsers, editors, and debuggers, and I provide the default output schema and the default conversion of structured results into the text content blocks that MCP clients render, which concrete tools override as needed.

For example, `MCPPulsarClassEdit` and `MCPPulsarMethodEdit` build on me to read and edit the buffers of open class and method editors, and `MCPToolPulsarDebugger` builds on me to drive open debuggers.

```smalltalk
MCPPulsarClassEdit new pulsarApplication
""Answers the running PulsarApplication, or nil if Pulsar is not running.""
```
"
Class {
	#name : 'MCPPulsarTool',
	#superclass : 'MCPTool',
	#category : 'Pulsar-Tool-LLM-MCP-Tools',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'MCP-Tools'
}

{ #category : 'testing' }
MCPPulsarTool class >> isAbstract [

	^ self = MCPPulsarTool
]

{ #category : 'scripts' }
MCPPulsarTool class >> toolGroup [

	^ #Pulsar
]

{ #category : 'defaults' }
MCPPulsarTool >> defaultOutputSchema [

	^ self standardOutputSchemaForDataProperties: #(  ) required: #(  )
]

{ #category : 'private - results' }
MCPPulsarTool >> formattedDataContentBlocks: aDictionary [

	^ #(  )
]

{ #category : 'accessing' }
MCPPulsarTool >> pulsarApplication [

	^ PulsarApplication running
]
