"
I am the Pulsar model for a method whose body is a literal array of arrays, that is, a table of rows.

I expose such a method as rows of strings so a tool can edit it cell by cell, and I know the method's original source together with the source span of the whole literal array and of each row. I answer a new method source from edited rows, keeping untouched rows, comments and layout intact. I exist so tabular methods (icon tables, color tables, mappings) can be edited as tables instead of as raw source.

I collaborate with PvMethodModel, my superclass, which owns the compiled-method entity I edit; with PulsarMethodTableEditor, which presents me as a table; and with the `<pulsarTableEditor: #(...)>` pragma, which marks a method as tabular and declares its column titles.

# Public API and Key Messages

- `#rows` answers the extracted rows, padded to the column count.
- `#updateWith:` recompiles the method from edited rows and answers whether it succeeded.
- `#columnTitles` answers the titles declared by the pragma.
- `PvMethodModel>>#editorTable:` creates me for a method carrying the pragma.

A method is table-editable when it carries the pragma:

	myIcons
		<pulsarTableEditor: #('Name' 'Icon')>

		^ #(
			('open' 'folder-open-outline')
			('close' 'close'))
"
Class {
	#name : 'PulsarMethodTableModel',
	#superclass : 'PvMethodModel',
	#instVars : [
		'rows',
		'originalSource',
		'arraySpan',
		'rowSpans'
	],
	#category : 'Pulsar-Tool-FileEditor-Model',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarMethodTableModel >> columnTitles [

	^ self pragma arguments first
]

{ #category : 'private' }
PulsarMethodTableModel >> ensureExtracted [
	"Extract the table rows and their source spans from the current method entity."

	| node |
	originalSource := self entity sourceCode.
	node := self literalArrayNode.
	node ifNil: [
			rows := #(  ).
			rowSpans := #(  ).
			^ self ].
	arraySpan := node start -> node stop.
	rowSpans := node contents collect: [ :eachNode | eachNode start -> eachNode stop ].
	rows := node value collect: [ :eachRow | self paddedRow: eachRow ]
]

{ #category : 'private' }
PulsarMethodTableModel >> literalArrayNode [
	"Answer the literal array node whose value this table edits, or nil if the method has no simple literal-array body."

	| ast firstStatement |
	ast := self entity ast.
	ast body statements isEmpty ifTrue: [ ^ nil ].
	firstStatement := ast body statements first.
	(firstStatement isKindOf: OCReturnNode) ifFalse: [ ^ nil ].
	^ (firstStatement value isKindOf: OCLiteralArrayNode)
		  ifTrue: [ firstStatement value ]
		  ifFalse: [ nil ]
]

{ #category : 'private' }
PulsarMethodTableModel >> literalRowTextFor: eachRow [
	"Answer the literal-array text for the given row (an array of strings). Trailing empty cells are trimmed to keep the source compact."

	| trimmed |
	trimmed := eachRow.
	[ trimmed isNotEmpty and: [ trimmed last asString isEmpty ] ] whileTrue: [ trimmed := trimmed allButLast ].
	^ String streamContents: [ :stream |
			  stream nextPut: $(.
			  trimmed
				  do: [ :each |
						  stream nextPut: $'.
						  stream nextPutAll: (each asString escapeCharacter: $').
						  stream nextPut: $' ]
				  separatedBy: [ stream space ].
			  stream nextPut: $) ]
]

{ #category : 'private' }
PulsarMethodTableModel >> newSourceFor: aCollectionOfRows [
	"Answer the method source obtained by splicing the given rows into the original literal-array text. Untouched rows keep their original text so comments and formatting are preserved."

	| originalRowCount position |
	self rows. "ensure extracted"
	arraySpan ifNil: [ self error: 'Method has no literal array body' ].
	originalRowCount := rowSpans size.
	position := arraySpan key.
	^ String streamContents: [ :stream |
			  stream nextPutAll: (originalSource copyFrom: 1 to: arraySpan key - 1).
			  1 to: originalRowCount do: [ :index |
					  | span |
					  span := rowSpans at: index.
					  position < span key ifTrue: [ stream nextPutAll: (originalSource copyFrom: position to: span key - 1) ].
					  index <= aCollectionOfRows size ifTrue: [
							  stream nextPutAll: ((aCollectionOfRows at: index) = (rows at: index)
									   ifTrue: [ originalSource copyFrom: span key to: span value ]
									   ifFalse: [ self literalRowTextFor: (aCollectionOfRows at: index) ]) ].
					  position := span value + 1 ].
			  (originalRowCount + 1 to: aCollectionOfRows size) do: [ :index |
					  stream cr.
					  stream tab.
					  stream tab.
					  stream nextPutAll: (self literalRowTextFor: (aCollectionOfRows at: index)) ].
			  stream nextPutAll: (originalSource copyFrom: position to: arraySpan value).
			  arraySpan value < originalSource size ifTrue: [
				  stream nextPutAll: (originalSource copyFrom: arraySpan value + 1 to: originalSource size) ] ]
]

{ #category : 'private' }
PulsarMethodTableModel >> paddedRow: eachRow [
	"Answer eachRow as an array of strings padded with empty strings to the column count."

	| cells |
	cells := eachRow isArray
		         ifTrue: [ eachRow collect: [ :each | each asString ] ]
		         ifFalse: [ { eachRow asString } ].
	^ (1 to: self columnTitles size) collect: [ :index |
			  index <= cells size
				  ifTrue: [ cells at: index ]
				  ifFalse: [ '' ] ]
]

{ #category : 'private' }
PulsarMethodTableModel >> pragma [

	^ self entity pragmaAt: #pulsarTableEditor:
]

{ #category : 'accessing - ui' }
PulsarMethodTableModel >> pulsarEditorClass [

	^ PulsarMethodTableEditor
]

{ #category : 'accessing' }
PulsarMethodTableModel >> rows [
	"Answer the extracted rows of the table (an array of arrays of strings, padded to the column count)."

	self entity sourceCode = originalSource ifFalse: [ self ensureExtracted ].
	^ rows
]

{ #category : 'updating' }
PulsarMethodTableModel >> updateWith: aCollectionOfRows [
	"Compile the method with the given rows, splicing them into the original source. Answer a boolean indicating success."

	^ self updateWith: (self newSourceFor: aCollectionOfRows) notifying: (SpCodeMethodInteractionModel on: self entity)
]

{ #category : 'accessing - ui' }
PulsarMethodTableModel >> windowTitle [

	^ 'Table'
]
