"
""Tests for PulsarMethodTableModel: extraction of literal-array method bodies, source splicing on update (comments and layout preservation), row add/remove, quoting, and protocol preservation.""
"
Class {
	#name : 'PulsarMethodTableModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Tool-FileEditor-Tests',
	#package : 'Pulsar-Tool-FileEditor-Tests'
}

{ #category : 'private' }
PulsarMethodTableModelTest >> newModel [

	^ PulsarMethodTableModel newEnvironment: nil entity: self class >> #sampleTableForTest
]

{ #category : 'private' }
PulsarMethodTableModelTest >> sampleSource [
	"Source of the sample table method compiled by setUp."

	^ 'sampleTableForTest
	<pulsarTableEditor: #(''A'' ''B'')>

	^ #(
		"section"
		(''one'' ''two'')
		(''three'')
		(''four'' ''five''))'
]

{ #category : 'running' }
PulsarMethodTableModelTest >> setUp [

	super setUp.
	self class compile: self sampleSource classified: #samples
]

{ #category : 'running' }
PulsarMethodTableModelTest >> tearDown [

	self class removeSelector: #sampleTableForTest.
	super tearDown
]

{ #category : 'tests' }
PulsarMethodTableModelTest >> testAddRow [

	| model rows |
	model := self newModel.
	rows := model rows deepCopy.
	rows := rows copyWith: #( 'six' 'seven' ).
	self assert: (model updateWith: rows).
	self assert: self class new sampleTableForTest equals: #( #( 'one' 'two' ) #( 'three' ) #( 'four' 'five' ) #( 'six' 'seven' ) )
]

{ #category : 'tests' }
PulsarMethodTableModelTest >> testColumnTitles [

	| model |
	model := self newModel.
	self assert: model columnTitles equals: #( 'A' 'B' )
]

{ #category : 'tests' }
PulsarMethodTableModelTest >> testExtractRows [

	| model |
	model := self newModel.
	self assert: model rows equals: #( #( 'one' 'two' ) #( 'three' '' ) #( 'four' 'five' ) )
]

{ #category : 'tests' }
PulsarMethodTableModelTest >> testProtocolPreserved [

	| model rows |
	model := self newModel.
	rows := model rows deepCopy.
	rows at: 3 put: #( 'quatre' 'cinq' ).
	self assert: (model updateWith: rows).
	self assert: (self class >> #sampleTableForTest) protocol name equals: #samples
]

{ #category : 'tests' }
PulsarMethodTableModelTest >> testQuoteEscaping [

	| model rows |
	model := self newModel.
	rows := model rows deepCopy.
	rows at: 2 put: #( 'it''s' 'fine' ).
	self assert: (model updateWith: rows).
	self assert: self class new sampleTableForTest equals: #( #( 'one' 'two' ) #( 'it''s' 'fine' ) #( 'four' 'five' ) )
]

{ #category : 'tests' }
PulsarMethodTableModelTest >> testRemoveRow [

	| model rows |
	model := self newModel.
	rows := model rows deepCopy allButFirst.
	self assert: (model updateWith: rows).
	self assert: self class new sampleTableForTest equals: #( #( 'three' ) #( 'four' 'five' ) )
]

{ #category : 'tests' }
PulsarMethodTableModelTest >> testUpdateChangedRowPreservesCommentsAndLayout [

	| model rows newMethod source |
	model := self newModel.
	rows := model rows deepCopy.
	rows at: 1 put: #( 'uno' 'dos' ).
	self assert: (model updateWith: rows).
	newMethod := self class >> #sampleTableForTest.
	source := newMethod sourceCode.
	self assert: (source includesSubstring: '"section"').
	self assert: (source includesSubstring: '<pulsarTableEditor: #(').
	self assert: (source includesSubstring: '(''uno'' ''dos'')').
	self assert: (source includesSubstring: '(''three'')').
	self assert: (source includesSubstring: '(''four'' ''five'')').
	self assert: self class new sampleTableForTest equals: #( #( 'uno' 'dos' ) #( 'three' ) #( 'four' 'five' ) )
]
