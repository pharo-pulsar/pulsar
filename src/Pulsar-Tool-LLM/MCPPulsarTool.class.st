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
