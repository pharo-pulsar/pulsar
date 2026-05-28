Class {
	#name : 'MCPToolPulsarDebugger',
	#superclass : 'MCPPulsarTool',
	#category : 'Pulsar-Tool-LLM-MCP-Tools',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'MCP-Tools'
}

{ #category : 'private' }
MCPToolPulsarDebugger >> debuggerModelAt: aWindowIndex [

	| models |
	models := self debuggerModels.
	(aWindowIndex between: 1 and: models size) ifFalse: [
			MCPCommandError signal:
				'No debugger at window index ' , aWindowIndex printString , '. ' , models size printString , ' debugger(s) open.' ].
	^ models at: aWindowIndex
]

{ #category : 'private' }
MCPToolPulsarDebugger >> debuggerModels [

	^ (self pulsarApplication windows select: [ :each | each isKindOf: PulsarDebugger ] thenCollect: [ :each | each model ]) asArray
]

{ #category : 'defaults' }
MCPToolPulsarDebugger >> defaultDescription [

	^ 'Interact with open Pulsar debuggers. list shows all debugger windows with stack summaries. inspect shows the full stack of a chosen debugger, including source code for each context. step performs stepping actions (stepInto, stepOver, stepThrough, proceed, restart) on the top context. evaluate runs Smalltalk code in a chosen context.'
]

{ #category : 'defaults' }
MCPToolPulsarDebugger >> defaultInputSchema [

	^ MCPStructureInputSchema new
		  type: 'object';
		  properties: {
				  ((self
					    stringEnumSchemaPropertyNamed: 'operation'
					    description: 'The debugger operation to perform.'
					    values: #( 'list' 'inspect' 'step' 'evaluate' ))
					   required: true;
					   yourself).
				  (self integerSchemaPropertyNamed: 'windowIndex' description: 'The 1-based index of the debugger window to operate on.').
				  (self
					   integerSchemaPropertyNamed: 'contextIndex'
					   description: 'The 1-based index of the stack context to inspect or evaluate in.').
				  ((self
					    stringEnumSchemaPropertyNamed: 'action'
					    description: 'The stepping action to perform.'
					    values: #( 'stepInto' 'stepOver' 'stepThrough' 'proceed' 'restart' ))
					   default: 'stepInto';
					   yourself).
				  (self schemaPropertyNamed: 'code' type: 'string' description: 'Smalltalk code to evaluate in the chosen context.') };
		  required: #( 'operation' );
		  additionalProperties: true;
		  yourself
]

{ #category : 'defaults' }
MCPToolPulsarDebugger >> defaultName [

	^ 'pulsar-debugger'
]

{ #category : 'defaults' }
MCPToolPulsarDebugger >> defaultOutputSchema [

	^ self
		  standardOutputSchemaForDataProperties: {
				  (self
					   stringArraySchemaNamed: 'debuggers'
					   description: 'List of debugger windows when operation=list.'
					   itemDescription: 'A debugger window entry.').
				  (self
					   stringArraySchemaNamed: 'stack'
					   description: 'Stack trace entries when operation=inspect.'
					   itemDescription: 'A stack context entry.').
				  (self schemaPropertyNamed: 'result' type: 'string' description: 'Step result or evaluated expression result.') }
		  required: #(  )
]

{ #category : 'defaults' }
MCPToolPulsarDebugger >> defaultTitle [

	^ 'Pulsar Debugger'
]

{ #category : 'private' }
MCPToolPulsarDebugger >> evaluateInDebuggerAt: windowIndex request: aRequest [
	"Evaluate Smalltalk code in a specific context of the chosen debugger."

	| model stack contextIndex context code result |
	model := self debuggerModelAt: windowIndex.
	stack := model stack.
	contextIndex := aRequest nonNegativeIntegerArgumentNamed: 'contextIndex' default: 1.
	context := stack at: contextIndex ifAbsent: [
			           ^ self
				             errorResultText:
				             'contextIndex ' , contextIndex printString , ' out of range (max ' , stack size printString , ').'
				             details: { (#max -> stack size) } asDictionary ].
	code := aRequest stringArgumentNamed: 'code'.
	code ifEmpty: [ ^ self errorResultText: 'code is required for evaluate.' details: Dictionary new ].
	result := context returnValueFromExpression: code.
	^ self
		  successResultText: 'Evaluated code in context ' , contextIndex printString , ' of debugger ' , windowIndex printString , '.'
		  data: {
				  (#windowIndex -> windowIndex).
				  (#contextIndex -> contextIndex).
				  (#resultClassName -> result class name).
				  (#resultPrintString -> (result printStringLimitedTo: 10000)) } asDictionary
]

{ #category : 'executing' }
MCPToolPulsarDebugger >> executeWithRequest: request [
	"Dispatch to list, inspect, step, or evaluate based on the operation argument."

	| operation windowIndex contextIndex |
	operation := request stringArgumentNamed: 'operation'.
	operation = 'list' ifTrue: [ ^ self listDebuggers ].
	windowIndex := request nonNegativeIntegerArgumentNamed: 'windowIndex' default: 0.
	windowIndex < 1 ifTrue: [
		^ self errorResultText: 'windowIndex is required for ' , operation details: { (#operation -> operation) } asDictionary ].
	operation = 'inspect' ifTrue: [
			contextIndex := request nonNegativeIntegerArgumentNamed: 'contextIndex' default: 0.
			^ self inspectDebuggerAt: windowIndex contextIndex: contextIndex ].
	operation = 'step' ifTrue: [ ^ self stepDebuggerAt: windowIndex request: request ].
	operation = 'evaluate' ifTrue: [ ^ self evaluateInDebuggerAt: windowIndex request: request ].
	^ self errorResultText: 'Unknown operation: ' , operation details: { (#operation -> operation) } asDictionary
]

{ #category : 'private - results' }
MCPToolPulsarDebugger >> formattedDataContentBlocks: aDictionary [
	"Format debugger list, stack inspect, or step/evaluate results as text content blocks."

	| debuggers stack resultText lines |
	debuggers := aDictionary at: #debuggers ifAbsent: [ nil ].
	debuggers ifNotNil: [
			debuggers isEmpty ifTrue: [ ^ #(  ) ].
			lines := debuggers collect: [ :eachDebugger |
					         '[' , (eachDebugger at: #windowIndex) printString , '] ' , (eachDebugger at: #name) , ' ('
					         , (eachDebugger at: #contextCount) printString , ' contexts) ' , (eachDebugger at: #topContext ifAbsent: [ '' ]) ].
			^ { (self textContent: (lines joinUsing: '
')) } ].
	stack := aDictionary at: #stack ifAbsent: [ nil ].
	stack ifNotNil: [
			stack isEmpty ifTrue: [ ^ #(  ) ].
			lines := stack collect: [ :eachContext | eachContext at: #name ].
			resultText := lines joinUsing: '
'.
			aDictionary at: #contextIndex ifPresent: [ :eachContextIndex |
					eachContextIndex > 0 ifTrue: [
							| sourceString |
							sourceString := stack first at: #sourceCode ifAbsent: [ '' ].
							sourceString ifNotEmpty: [ resultText := resultText , '

' , sourceString ] ] ].
			^ { (self textContent: resultText) } ].
	^ #(  )
]

{ #category : 'private' }
MCPToolPulsarDebugger >> inspectDebuggerAt: windowIndex contextIndex: contextIndex [
	"Inspect the stack of a debugger, or a single context if contextIndex is provided."

	| model stack contexts |
	model := self debuggerModelAt: windowIndex.
	stack := model stack.
	contexts := (contextIndex > 0
		             ifTrue: [
				             { (stack
					              at: contextIndex
					              ifAbsent: [
					              ^ self errorResultText: 'contextIndex out of range.' details: { (#max -> stack size) } asDictionary ]) } ]
		             ifFalse: [ stack ]) collect: [ :eachContext |
			            | method |
			            method := eachContext realMethod.
			            {
				            (#name -> eachContext name).
				            (#methodClass -> eachContext methodClassName).
				            (#methodName -> (method ifNotNil: [ method selector asString ] ifNil: [ '' ])).
				            (#sourceCode -> eachContext sourceCode) } asDictionary ].
	^ self
		  successResultText: 'Debugger ' , windowIndex printString , ' ' , (contextIndex > 0
				   ifTrue: [ 'context ' , contextIndex printString ]
				   ifFalse: [ 'full stack, ' , stack size printString , ' contexts' ]) , '.'
		  data: {
				  (#windowIndex -> windowIndex).
				  (#contextIndex -> contextIndex).
				  (#stack -> contexts).
				  (#totalContexts -> stack size) } asDictionary
]

{ #category : 'private' }
MCPToolPulsarDebugger >> listDebuggers [

	| models |
	models := self debuggerModels.
	^ self
		  successResultText: models size printString , ' debugger(s) open.'
		  data: { (#debuggers -> (models collectWithIndex: [ :eachModel :eachIndex |
					    | stack |
					    stack := eachModel stack.
					    {
						    (#windowIndex -> eachIndex).
						    (#name -> eachModel name).
						    (#contextCount -> stack size).
						    (#topContext -> (stack ifNotEmpty: [ stack first name ] ifEmpty: [ '' ])) } asDictionary ])) } asDictionary
]

{ #category : 'private' }
MCPToolPulsarDebugger >> stepDebuggerAt: windowIndex request: aRequest [
	"Apply a stepping action to the top context of the chosen debugger."

	| model stack topContext action |
	model := self debuggerModelAt: windowIndex.
	stack := model stack.
	stack ifEmpty: [ ^ self errorResultText: 'Debugger has no stack.' details: { (#windowIndex -> windowIndex) } asDictionary ].
	topContext := stack first.
	action := aRequest stringArgumentNamed: 'action' default: 'stepInto'.
	action = 'stepInto' ifTrue: [ topContext stepInto ].
	action = 'stepOver' ifTrue: [ topContext stepOver ].
	action = 'stepThrough' ifTrue: [ topContext stepThrough ].
	action = 'proceed' ifTrue: [ topContext proceedDebugSession ].
	action = 'restart' ifTrue: [ topContext restartCurrentContext ].
	^ self successResultText: 'Performed ' , action , ' on debugger ' , windowIndex printString , '.' data: {
			  (#windowIndex -> windowIndex).
			  (#action -> action).
			  (#newTopContext -> topContext name) } asDictionary
]
