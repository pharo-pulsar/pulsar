"
I am an MCP tool that reads and edits the content currently open in a Pulsar class editor.

I address class editors by their model full name (for example Object). A class editor has two editable regions: a markdown class comment (commentPresenter) and a fluid class definition (editorPresenter). The write operation targets one of them through the target argument, updating the editor buffer and marking it dirty for review by default, or saving it immediately when the submit flag is true. I inherit editor lookup and GTK main-loop marshalling from MCPPulsarToolEdit.
"
Class {
	#name : 'MCPPulsarClassEdit',
	#superclass : 'MCPPulsarToolEdit',
	#category : 'Pulsar-Tool-LLM-MCP-Tools',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'MCP-Tools'
}

{ #category : 'operations' }
MCPPulsarClassEdit >> bufferClassEditor: anEditor target: targetString source: sourceString [
	  "Place the source in the target editor buffer without saving it, marking it dirty for review."

	  | dirty |
	  self onUIThreadDo: [
			  (targetString = 'comment'
				   ifTrue: [ anEditor commentPresenter ]
				   ifFalse: [ anEditor editorPresenter ]) text: sourceString.
			  dirty := targetString = 'comment'
				           ifTrue: [ anEditor isCommentDirty ]
				           ifFalse: [ anEditor isDirty ] ].
	  ^ self successResultText: 'Updated the buffer of ' , anEditor model fullName , ' (not saved).' data: {
			    (#operation -> 'write').
			    (#name -> anEditor model fullName).
			    (#target -> targetString).
			    (#mode -> 'buffered').
			    (#submitted -> false).
			    (#dirty -> dirty).
			    (#source -> sourceString) } asDictionary
]

{ #category : 'operations' }
MCPPulsarClassEdit >> classEditorInfoFor: anEditor index: anIndex [
	  "Answer a structured description of a class editor."

	  | model |
	  model := anEditor model.
	  ^ {
		    (#index -> anIndex).
		    (#name -> model fullName).
		    (#dirty -> anEditor isDirty).
		    (#commentDirty -> anEditor isCommentDirty) } asDictionary
]

{ #category : 'accessing' }
MCPPulsarClassEdit >> classEditorNamed: aString [
	  "Answer the open class editor whose model full name matches aString, or nil."

	  | editor |
	  aString ifNil: [ ^ nil ].
	  editor := self editorMatchingModelFullName: aString.
	  editor ifNil: [ ^ nil ].
	  ^ (editor isKindOf: PulsarClassEditor)
		    ifTrue: [ editor ]
		    ifFalse: [ nil ]
]

{ #category : 'accessing' }
MCPPulsarClassEdit >> defaultDescription [

	  ^ 'Read and edit the content currently open in a Pulsar class editor. operation=list lists the open class editors. operation=read returns the markdown class comment and the fluid class definition in the editor buffers. operation=write places new content in the editor for the given target (comment or definition); by default it only marks the buffer dirty for review, and with submit=true it saves it immediately. Class editors are addressed by their model full name, for example Object.'
]

{ #category : 'accessing' }
MCPPulsarClassEdit >> defaultInputSchema [

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
					     description: 'The editor model full name, for example Object. Required for read and write.').
				    (self
					     stringEnumSchemaPropertyNamed: 'target'
					     description:
						     'The region of the class editor to write. comment is the markdown class comment; definition is the fluid class definition. Required for write.'
					     values: #( 'comment' 'definition' )).
				    (self
					     schemaPropertyNamed: 'source'
					     type: 'string'
					     description: 'The full new content to place in the editor. Required for write.').
				    (self
					     booleanSchemaPropertyNamed: 'submit'
					     description:
						     'When true, write saves the content immediately. When false (default) it only updates the editor buffer and marks it dirty for review.'
					     default: false) };
		    required: #( 'operation' );
		    additionalProperties: false;
		    yourself
]

{ #category : 'accessing' }
MCPPulsarClassEdit >> defaultName [

	  ^ 'pulsar-class-edit'
]

{ #category : 'accessing' }
MCPPulsarClassEdit >> defaultOutputSchema [

	  | editorItemSchema |
	  editorItemSchema := MCPStructureProperties new
		                      type: 'object';
		                      properties: {
				                      (self schemaPropertyNamed: 'index' type: 'integer' description: '1-based index of the class editor.').
				                      (self
					                       schemaPropertyNamed: 'name'
					                       type: 'string'
					                       description: 'The editor model full name, for example Object.').
				                      (self
					                       schemaPropertyNamed: 'dirty'
					                       type: 'boolean'
					                       description: 'Whether the editor has unsaved changes.').
				                      (self
					                       schemaPropertyNamed: 'commentDirty'
					                       type: 'boolean'
					                       description: 'Whether the class comment has unsaved changes.') };
		                      required: #( 'index' 'name' 'dirty' 'commentDirty' );
		                      additionalProperties: false;
		                      yourself.
	  ^ self
		    standardOutputSchemaForDataProperties: {
				    (self schemaPropertyNamed: 'operation' type: 'string' description: 'The operation that was performed.').
				    ((self schemaPropertyNamed: 'editors' type: 'array' description: 'The open class editors when operation=list.')
					     items: editorItemSchema;
					     yourself).
				    (self schemaPropertyNamed: 'name' type: 'string' description: 'The editor model full name operated on.').
				    (self schemaPropertyNamed: 'comment' type: 'string' description: 'The markdown class comment in the editor buffer.').
				    (self schemaPropertyNamed: 'definition' type: 'string' description: 'The fluid class definition in the editor buffer.').
				    (self schemaPropertyNamed: 'dirty' type: 'boolean' description: 'Whether the editor has unsaved changes.').
				    (self schemaPropertyNamed: 'commentDirty' type: 'boolean' description: 'Whether the class comment has unsaved changes.').
				    (self
					     schemaPropertyNamed: 'target'
					     type: 'string'
					     description: 'For write: the region of the class editor updated (comment or definition).').
				    (self
					     schemaPropertyNamed: 'mode'
					     type: 'string'
					     description: 'For write: buffered when the buffer was updated without saving, or submitted when it was saved.').
				    (self schemaPropertyNamed: 'submitted' type: 'boolean' description: 'For write with submit: whether saving succeeded.').
				    (self schemaPropertyNamed: 'source' type: 'string' description: 'The content placed in the editor buffer.') }
		    required: #(  )
]

{ #category : 'accessing' }
MCPPulsarClassEdit >> defaultTitle [

	  ^ 'Pulsar Class Editor'
]

{ #category : 'operations' }
MCPPulsarClassEdit >> errorNoClassEditorNamed: aString [
	  "Answer an error result when no open class editor matches the given name."

	  ^ self errorResultText: 'No open class editor for ' , aString printString , '.' details: {
			    (#name -> aString).
			    (#availableNames -> (self openClassEditors collect: [ :each | each model fullName ]) asArray) } asDictionary
]

{ #category : 'executing' }
MCPPulsarClassEdit >> executeWithRequest: request [
	  "Dispatch to list, read, or write based on the operation argument."

	  | operation name |
	  operation := request stringArgumentNamed: 'operation'.
	  operation ifNil: [ ^ self errorResultText: 'operation is required.' details: Dictionary new ].
	  operation = 'list' ifTrue: [ ^ self listClassEditors ].
	  name := request stringArgumentNamed: 'name'.
	  operation = 'read' ifTrue: [ ^ self readClassEditorNamed: name ].
	  operation = 'write' ifTrue: [ ^ self writeClassEditorNamed: name request: request ].
	  ^ self errorResultText: 'Unknown operation: ' , operation details: {
			    (#operation -> operation).
			    (#name -> name) } asDictionary
]

{ #category : 'accessing' }
MCPPulsarClassEdit >> formattedDataContentBlocks: aDictionary [
	  "Render the editor list or the comment and definition as text content blocks."

	  | editors lines comment definition |
	  editors := aDictionary at: #editors ifAbsent: [ nil ].
	  editors ifNotNil: [
			  editors isEmpty ifTrue: [ ^ #(  ) ].
			  lines := editors collect: [ :each |
					           '[' , (each at: #index) printString , '] ' , (each at: #name) , ((each at: #dirty)
						            ifTrue: [ ' (dirty)' ]
						            ifFalse: [ '' ]) ].
			  ^ { (self textContent: (lines joinUsing: String cr)) } ].
	  comment := aDictionary at: #comment ifAbsent: [ nil ].
	  comment ifNotNil: [
			  definition := aDictionary at: #definition ifAbsent: [ '' ].
			  ^ { (self textContent: 'Comment:' , String cr , comment , String cr , String cr , 'Definition:' , String cr , definition) } ].
	  ^ #(  )
]

{ #category : 'operations' }
MCPPulsarClassEdit >> listClassEditors [
	  "Answer the list of open class editors."

	  | editors |
	  editors := self openClassEditors.
	  ^ self successResultText: editors size printString , ' class editor(s) open.' data: {
			    (#operation -> 'list').
			    (#editors
			     -> (editors collectWithIndex: [ :eachEditor :eachIndex | self classEditorInfoFor: eachEditor index: eachIndex ]) asArray) }
			    asDictionary
]

{ #category : 'accessing' }
MCPPulsarClassEdit >> openClassEditors [
	  "Answer the open class editor presenters, in browsing order."

	  ^ self openEditors select: [ :each | each isKindOf: PulsarClassEditor ]
]

{ #category : 'operations' }
MCPPulsarClassEdit >> readClassEditorNamed: aString [
	  "Answer the content currently in the editor buffers: the markdown class comment and the fluid class definition."

	  | editor comment definition |
	  editor := self classEditorNamed: aString.
	  editor ifNil: [ ^ self errorNoClassEditorNamed: aString ].
	  self onUIThreadDo: [
			  comment := editor commentPresenter text.
			  definition := editor editorPresenter text ].
	  ^ self successResultText: 'Read ' , editor model fullName , '.' data: {
			    (#operation -> 'read').
			    (#name -> editor model fullName).
			    (#comment -> comment).
			    (#definition -> definition).
			    (#dirty -> editor isDirty).
			    (#commentDirty -> editor isCommentDirty) } asDictionary
]

{ #category : 'operations' }
MCPPulsarClassEdit >> submitClassEditor: anEditor target: targetString source: sourceString [
	  "Save the source through the editor and answer the result."

	  | success |
	  success := self onUIThreadDo: [
			             targetString = 'comment'
				             ifTrue: [
						             anEditor commentPresenter text: sourceString.
						             anEditor doSaveComment: sourceString.
						             true ]
				             ifFalse: [
						             anEditor editorPresenter text: sourceString.
						             anEditor doSubmit: sourceString ] ].
	  success ifFalse: [
			  ^ self errorResultText: 'Saving the ' , targetString , ' of ' , anEditor model fullName , ' failed.' details: {
					    (#name -> anEditor model fullName).
					    (#target -> targetString).
					    (#mode -> 'submitted') } asDictionary ].
	  ^ self successResultText: 'Submitted and saved ' , anEditor model fullName , '.' data: {
			    (#operation -> 'write').
			    (#name -> anEditor model fullName).
			    (#target -> targetString).
			    (#mode -> 'submitted').
			    (#submitted -> true).
			    (#dirty -> anEditor isDirty).
			    (#source -> sourceString) } asDictionary
]

{ #category : 'operations' }
MCPPulsarClassEdit >> writeClassEditorNamed: aString request: request [
	  "Update the editor buffer for the given target with the given source, optionally saving it."

	  | editor target source submit |
	  editor := self classEditorNamed: aString.
	  editor ifNil: [ ^ self errorNoClassEditorNamed: aString ].
	  target := request stringArgumentNamed: 'target'.
	  (target = 'comment' or: [ target = 'definition' ]) ifFalse: [
			  ^ self errorResultText: 'target must be comment or definition for write.' details: {
					    (#name -> editor model fullName).
					    (#target -> target) } asDictionary ].
	  source := request stringArgumentNamed: 'source'.
	  source ifNil: [
			  ^ self errorResultText: 'source is required for write.' details: {
					    (#name -> editor model fullName).
					    (#target -> target) } asDictionary ].
	  submit := request booleanArgumentNamed: 'submit' default: false.
	  ^ submit
		    ifTrue: [ self submitClassEditor: editor target: target source: source ]
		    ifFalse: [ self bufferClassEditor: editor target: target source: source ]
]
