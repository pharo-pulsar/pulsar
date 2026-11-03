"
I am the abstract base for MCP tools that interact with the running Pulsar IDE.

`MCPTool` defines a tool's public metadata and execution mechanics. I add the Pulsar-specific half: I am how my subclasses reach the running `PulsarApplication`, from which they obtain IDE state such as open browsers, editors, and projects, and I provide the default output schema and the default conversion of structured results into the text content blocks that MCP clients render, which concrete tools override as needed.

I also enumerate the open Pulsar browser windows, main browser first, and marshal presenter mutations onto the GTK main loop.

For example, `MCPPulsarClassEdit` and `MCPPulsarMethodEdit` build on me to read and edit the buffers of open class and method editors, `MCPToolPulsarDebugger` builds on me to drive open debuggers, and `MCPPulsarProject` builds on me to open and close projects in browser trees.

```smalltalk
MCPPulsarClassEdit new pulsarApplication
""""Answers the running PulsarApplication, or nil if Pulsar is not running.""""
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
MCPPulsarTool >> mainBrowser [
	"Answer the main Pulsar browser, or nil if it is not open."

	^ self pulsarApplication ifNotNil: [ :application | application pulsarBrowser ]
]

{ #category : 'accessing' }
MCPPulsarTool >> onUIThreadDo: aBlock [
	"Run aBlock on the GTK main loop and answer its result."

	| result |
	self pulsarApplication ifNil: [ ^ aBlock value ] ifNotNil: [ :application | application defer: [ result := aBlock value ] ].
	^ result
]

{ #category : 'accessing' }
MCPPulsarTool >> pulsarApplication [

	^ PulsarApplication running
]

{ #category : 'accessing' }
MCPPulsarTool >> pulsarBrowsers [
	"Answer the open Pulsar browser windows, the main browser first."

	| browsers main |
	self pulsarApplication ifNil: [ ^ #(  ) ].
	main := self mainBrowser.
	browsers := (self pulsarApplication windows select: [ :each | each isPulsarBrowser ]) asOrderedCollection.
	main ifNotNil: [
			browsers remove: main ifAbsent: [ ].
			browsers addFirst: main ].
	^ browsers
]
