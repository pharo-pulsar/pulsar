"
I am an MCP tool that reads and edits the source currently open in a Pulsar method editor.

I address method editors by their model full name (for example Object>>at:put: or Object class>>foo). The write operation updates the editor buffer and marks it dirty by default, or compiles it immediately when the submit flag is true. I inherit editor lookup and GTK main-loop marshalling from MCPPulsarToolEdit.
"
Class {
	#name : 'MCPPulsarMethodEdit',
	#superclass : 'MCPPulsarToolEdit',
	#category : 'Pulsar-Tool-LLM-MCP-Tools',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'MCP-Tools'
}

{ #category : 'operations' }
MCPPulsarMethodEdit >> bufferMethodEditor: anEditor source: aString [
	"Place the source in the editor buffer without compiling it, marking it dirty for review."

	self onUIThreadDo: [
			   anEditor editorPresenter text: aString.
			          aString ~= anEditor originalContent ifTrue: [ anEditor markDirty ] ].
	  ^ self successResultText: 'Updated the buffer of ' , anEditor model fullName , ' (not compiled).' data: {
			(#operation -> 'write').
			(#name -> anEditor model fullName).
			(#className -> anEditor model methodClassName).
			(#selector -> anEditor model selector asString).
			(#classSide -> anEditor model isInstanceSide not).
			(#mode -> 'buffered').
			(#submitted -> false).
			(#dirty -> anEditor isDirty).
			(#source -> aString) } asDictionary
]

{ #category : 'accessing' }
MCPPulsarMethodEdit >> defaultDescription [

	^ 'Read and edit the source currently open in a Pulsar method editor. operation=list lists the open method editors. operation=read returns the source in a method editor buffer. operation=write places full method source in the editor buffer; by default it only marks the buffer dirty for review, and with submit=true it compiles immediately. Method editors are addressed by their model full name, for example Object>>at:put: or Object class>>foo.'
]

{ #category : 'accessing' }
MCPPulsarMethodEdit >> defaultInputSchema [

	^ MCPStructureInputSchema new
		  type: 'object';
		  properties: {
				  (self
					   stringEnumSchemaPropertyNamed: 'operation'
					   description: 'The editor operation to perform.'
					   values: #( 'list' 'read' 'write' )).
				  (self
					   schemaPropertyNamed: 'name'
					   type: 'string'
					   description: 'The editor model full name, for example Object>>at:put: or Object class>>foo. Required for read and write.').
				  (self
					   schemaPropertyNamed: 'source'
					   type: 'string'
					   description: 'The full new method source to place in the editor. Required for write.').
				  (self
					   booleanSchemaPropertyNamed: 'submit'
					   description:
						   'When true, write compiles the source immediately. When false (default) it only updates the editor buffer and marks it dirty for review.'
					   default: false) };
		  required: #( 'operation' );
		  additionalProperties: false;
		  yourself
]

{ #category : 'accessing' }
MCPPulsarMethodEdit >> defaultName [

	^ 'pulsar-method-edit'
]

{ #category : 'accessing' }
MCPPulsarMethodEdit >> defaultOutputSchema [

	| editorItemSchema |
	editorItemSchema := MCPStructureProperties new
		                    type: 'object';
		                    properties: {
				                    (self schemaPropertyNamed: 'index' type: 'integer' description: '1-based index of the method editor.').
				                    (self
					                     schemaPropertyNamed: 'name'
					                     type: 'string'
					                     description: 'The editor model full name, for example Object>>at:put:.').
				                    (self schemaPropertyNamed: 'className' type: 'string' description: 'The class defining the method.').
				                    (self schemaPropertyNamed: 'selector' type: 'string' description: 'The method selector.').
				                    (self
					                     schemaPropertyNamed: 'classSide'
					                     type: 'boolean'
					                     description: 'Whether the method is on the class side.').
				                    (self schemaPropertyNamed: 'dirty' type: 'boolean' description: 'Whether the editor has unsaved changes.') };
		                    required: #( 'index' 'name' 'className' 'selector' 'classSide' 'dirty' );
		                    additionalProperties: false;
		                    yourself.
	^ self
		  standardOutputSchemaForDataProperties: {
				  (self schemaPropertyNamed: 'operation' type: 'string' description: 'The operation that was performed.').
				  ((self schemaPropertyNamed: 'editors' type: 'array' description: 'The open method editors when operation=list.')
					   items: editorItemSchema;
					   yourself).
				  (self schemaPropertyNamed: 'name' type: 'string' description: 'The editor model full name operated on.').
				  (self schemaPropertyNamed: 'className' type: 'string' description: 'The class defining the method.').
				  (self schemaPropertyNamed: 'selector' type: 'string' description: 'The method selector.').
				  (self schemaPropertyNamed: 'classSide' type: 'boolean' description: 'Whether the method is on the class side.').
				  (self schemaPropertyNamed: 'dirty' type: 'boolean' description: 'Whether the editor has unsaved changes.').
				  (self
					   schemaPropertyNamed: 'mode'
					   type: 'string'
					   description: 'For write: buffered when the buffer was updated without compiling, or submitted when it was compiled.').
				  (self schemaPropertyNamed: 'submitted' type: 'boolean' description: 'For write with submit: whether compilation succeeded.').
				  (self schemaPropertyNamed: 'source' type: 'string' description: 'The source in the editor buffer.') }
		  required: #(  )
]

{ #category : 'accessing' }
MCPPulsarMethodEdit >> defaultTitle [

	^ 'Pulsar Method Editor'
]

{ #category : 'operations' }
MCPPulsarMethodEdit >> errorNoMethodEditorNamed: aString [
	  "Answer an error result when no open method editor matches the given name."

	  ^ self errorResultText: 'No open method editor for ' , aString printString , '.' details: {
			    (#name -> aString).
			    (#availableNames -> (self openMethodEditors collect: [ :each | each model fullName ]) asArray) } asDictionary
]

{ #category : 'executing' }
MCPPulsarMethodEdit >> executeWithRequest: request [
	"Dispatch to list, read, or write based on the operation argument."

	| operation name |
	operation := request stringArgumentNamed: 'operation'.
	operation ifNil: [ ^ self errorResultText: 'operation is required.' details: Dictionary new ].
	operation = 'list' ifTrue: [ ^ self listMethodEditors ].
	name := request stringArgumentNamed: 'name'.
	operation = 'read' ifTrue: [ ^ self readMethodEditorNamed: name ].
	operation = 'write' ifTrue: [ ^ self writeMethodEditorNamed: name request: request ].
	^ self errorResultText: 'Unknown operation: ' , operation details: {
			  (#operation -> operation).
			  (#name -> name) } asDictionary
]

{ #category : 'accessing' }
MCPPulsarMethodEdit >> formattedDataContentBlocks: aDictionary [
	  "Render the editor list or the source as text content blocks."

	  | editors source |
	  editors := aDictionary at: #editors ifAbsent: [ nil ].
	  editors ifNotNil: [
			  editors isEmpty ifTrue: [ ^ #(  ) ].
			  ^ { (self textContent: ((editors collect: [ :each |
						       '[' , (each at: #index) printString , '] ' , (each at: #name) , ((each at: #dirty)
							        ifTrue: [ ' (dirty)' ]
							        ifFalse: [ '' ]) ]) joinUsing: String cr)) } ].
	  source := aDictionary at: #source ifAbsent: [ nil ].
	  source ifNotNil: [ ^ { (self textContent: source) } ].
	  ^ #(  )
]

{ #category : 'operations' }
MCPPulsarMethodEdit >> listMethodEditors [
	  "Answer the list of open method editors."

	  | editors |
	  editors := self openMethodEditors.
	  ^ self successResultText: editors size printString , ' method editor(s) open.' data: {
			    (#operation -> 'list').
			    (#editors
			     -> (editors collectWithIndex: [ :eachEditor :eachIndex | self methodEditorInfoFor: eachEditor index: eachIndex ]) asArray) }
			    asDictionary
]

{ #category : 'operations' }
MCPPulsarMethodEdit >> methodEditorInfoFor: anEditor index: anIndex [
	"Answer a structured description of a method editor."

	| model |
	model := anEditor model.
	^ {
		  (#index -> anIndex).
		  (#name -> model fullName).
		  (#className -> model methodClassName).
		  (#selector -> model selector asString).
		  (#classSide -> model isInstanceSide not).
		  (#dirty -> anEditor isDirty) } asDictionary
]

{ #category : 'accessing' }
MCPPulsarMethodEdit >> methodEditorNamed: aString [
	"Answer the open method editor whose model full name matches aString, or nil."

	| editor |
	aString ifNil: [ ^ nil ].
	editor := self editorMatchingModelFullName: aString.
	editor ifNil: [ ^ nil ].
	^ (editor isKindOf: PulsarMethodEditor)
		  ifTrue: [ editor ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
MCPPulsarMethodEdit >> openMethodEditors [
	"Answer the open method editor presenters, in browsing order."

	^ self openEditors select: [ :each | each isKindOf: PulsarMethodEditor ]
]

{ #category : 'operations' }
MCPPulsarMethodEdit >> readMethodEditorNamed: aString [
	"Answer the source currently in the editor buffer."

	| editor source |
	editor := self methodEditorNamed: aString.
	editor ifNil: [ ^ self errorNoMethodEditorNamed: aString ].
	source := self onUIThreadDo: [ editor editorPresenter text ].
	^ self successResultText: 'Read ' , editor model fullName , '.' data: {
			  (#operation -> 'read').
			  (#name -> editor model fullName).
			  (#className -> editor model methodClassName).
			  (#selector -> editor model selector asString).
			  (#classSide -> editor model isInstanceSide not).
			  (#dirty -> editor isDirty).
			  (#source -> source) } asDictionary
]

{ #category : 'operations' }
MCPPulsarMethodEdit >> submitMethodEditor: anEditor source: aString [
	  "Compile the source through the editor and answer the result."

	  | compiled |
	  compiled := self onUIThreadDo: [ anEditor doSubmit: aString ].
	  compiled ifFalse: [
			  ^ self errorResultText: 'Compilation of ' , anEditor model fullName , ' failed.' details: {
					    (#name -> anEditor model fullName).
					    (#mode -> 'submitted') } asDictionary ].
	  ^ self successResultText: 'Submitted and compiled ' , anEditor model fullName , '.' data: {
			    (#operation -> 'write').
			    (#name -> anEditor model fullName).
			    (#className -> anEditor model methodClassName).
			    (#selector -> anEditor model selector asString).
			    (#classSide -> anEditor model isInstanceSide not).
			    (#mode -> 'submitted').
			    (#submitted -> true).
			    (#dirty -> anEditor isDirty).
			    (#source -> aString) } asDictionary
]

{ #category : 'operations' }
MCPPulsarMethodEdit >> writeMethodEditorNamed: aString request: request [
	"Update the editor buffer with the given source, optionally compiling it."

	| editor source submit |
	editor := self methodEditorNamed: aString.
	editor ifNil: [ ^ self errorNoMethodEditorNamed: aString ].
	source := request stringArgumentNamed: 'source'.
	source ifNil: [
		^ self errorResultText: 'source is required for write.' details: { (#name -> editor model fullName) } asDictionary ].
	submit := request booleanArgumentNamed: 'submit' default: false.
	^ submit
		     ifTrue: [ self submitMethodEditor: editor source: source ]
		     ifFalse: [ self bufferMethodEditor: editor source: source ]
]
