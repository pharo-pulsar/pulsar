"
""This is a model to edit a method whose body is a literal array of arrays (a table of rows) as a table.

It wraps a compiled method decorated with the <pulsarTableEditor: #(columnTitles...)> pragma. It extracts the rows from the method AST and, when saved, regenerates the method source by splicing the new row text into the original source so comments and layout of untouched rows are preserved.""
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

{ #category : 'accessing' }
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
