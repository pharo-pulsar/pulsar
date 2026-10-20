Class {
	#name : 'PulsarMethodSourceModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Tool-FileEditor-Model',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Model'
}

{ #category : 'tests' }
PulsarMethodSourceModelTest >> fStringExample [

	^ f'test [42]'
]

{ #category : 'samples' }
PulsarMethodSourceModelTest >> fStringFormExample [

	<pulsarSourceEditor: 'css'>
	^ f'plain text'
]

{ #category : 'samples' }
PulsarMethodSourceModelTest >> fStringUpdateExample [
	"this comment must survive"

	<pulsarSourceEditor: 'css'>
	<pulsarExamplePragma: #keep>
	^ f'new { color: red; }'
]

{ #category : 'samples' }
PulsarMethodSourceModelTest >> invalidFStringExample [

	<pulsarSourceEditor: 'css'>
	^ f'original'
]

{ #category : 'samples' }
PulsarMethodSourceModelTest >> noEmbeddedTextExample [

	<pulsarSourceEditor: 'css'>
	^ 42
]

{ #category : 'samples' }
PulsarMethodSourceModelTest >> plainLiteralUpdateExample [
	"keep this too"

	<pulsarSourceEditor: 'css'>
	<pulsarExamplePragma: #keep>
	^ 'it''s fine'
]

{ #category : 'tests' }
PulsarMethodSourceModelTest >> testSourceCodeWithFString [
	| model |

	model := PulsarMethodSourceModel newEnvironment: nil entity: self class>>#fStringExample.
	
	self assert: model sourceCode equals: 'test [42]'
]

{ #category : 'tests' }
PulsarMethodSourceModelTest >> testUpdateWithFStringKeepsFStringForm [

	| model |
	model := PulsarMethodSourceModel newEnvironment: nil entity: self class >> #fStringFormExample.
	self assert: (model updateWith: 'plain text').

	self assert: ((self class >> #fStringFormExample) sourceCode includesSubstring: 'f''plain text''').
	self assert: self class new fStringFormExample equals: 'plain text'
]

{ #category : 'tests' }
PulsarMethodSourceModelTest >> testUpdateWithFStringPreservesMethodParts [

	| model source |
	model := PulsarMethodSourceModel newEnvironment: nil entity: self class >> #fStringUpdateExample.
	self assert: (model updateWith: 'new { color: red; }').

	source := (self class >> #fStringUpdateExample) sourceCode.
	self assert: (source includesSubstring: '<pulsarSourceEditor: ''css''>').
	self assert: (source includesSubstring: '<pulsarExamplePragma: #keep>').
	self assert: (source includesSubstring: '"this comment must survive"').
	self assert: (source includesSubstring: 'f''new { color: red; }''').
	self assert: model sourceCode equals: 'new { color: red; }'
]

{ #category : 'tests' }
PulsarMethodSourceModelTest >> testUpdateWithInvalidFStringAnswersFalse [

	| model |
	model := PulsarMethodSourceModel newEnvironment: nil entity: self class >> #invalidFStringExample.
	self deny: (model updateWith: 'unclosed [').
	self assert: ((self class >> #invalidFStringExample) sourceCode includesSubstring: 'f''original''')
]

{ #category : 'tests' }
PulsarMethodSourceModelTest >> testUpdateWithNoEmbeddedTextAnswersFalse [

	| model |
	model := PulsarMethodSourceModel newEnvironment: nil entity: self class >> #noEmbeddedTextExample.
	self deny: (model updateWith: 'anything').
	self assert: self class new noEmbeddedTextExample equals: 42
]

{ #category : 'tests' }
PulsarMethodSourceModelTest >> testUpdateWithPlainLiteralPreservesMethodParts [

	| model source |
	model := PulsarMethodSourceModel newEnvironment: nil entity: self class >> #plainLiteralUpdateExample.
	self assert: (model updateWith: 'it''s fine').

	source := (self class >> #plainLiteralUpdateExample) sourceCode.
	self assert: (source includesSubstring: '<pulsarSourceEditor: ''css''>').
	self assert: (source includesSubstring: '<pulsarExamplePragma: #keep>').
	self assert: (source includesSubstring: '"keep this too"').
	self assert: (source includesSubstring: '''it''''s fine''').
	self assert: self class new plainLiteralUpdateExample equals: 'it''s fine'
]
