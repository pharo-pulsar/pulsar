"
I test the PulsarFFIModel: detection of simple ffiCall: methods, C-style signature extraction, and the source splice used to save edits.
"
Class {
	#name : 'PulsarFFIModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Tool-FileEditor-Tests',
	#package : 'Pulsar-Tool-FileEditor-Tests'
}

{ #category : 'samples' }
PulsarFFIModelTest >> newModel [

	^ PulsarFFIModel newEnvironment: nil entity: self class >> #sampleFFICall:
]

{ #category : 'samples' }
PulsarFFIModelTest >> newMultiModel [

	^ PulsarFFIModel newEnvironment: nil entity: self class >> #sampleFFIMulti
]

{ #category : 'samples' }
PulsarFFIModelTest >> sampleFFICall: value [
	self ffiCall: #(int my_c_function (self, long value))
]

{ #category : 'samples' }
PulsarFFIModelTest >> sampleFFIMulti [
	self ffiCall: #(void my_multi (
		self,
		"char *"char *ptr,
		"gpointer"void *arg))
]

{ #category : 'samples' }
PulsarFFIModelTest >> sampleFFISource [
	"Source of the sample ffi method compiled by setUp."

	^ 'sampleFFICall: value
	self ffiCall: #(int my_c_function (self, int value))'
]

{ #category : 'samples' }
PulsarFFIModelTest >> sampleMultiSource [
	"Source of a multi-line ffi sample with cast types, compiled by setUp."

	^ 'sampleFFIMulti
	self ffiCall: #(void my_multi (
		self,
		"char *"char *ptr,
		"gpointer"void *arg))'
]

{ #category : 'samples' }
PulsarFFIModelTest >> samplePlain [
	^ 42
]

{ #category : 'samples' }
PulsarFFIModelTest >> samplePlainSource [
	"Source of a plain (non-ffi) method compiled by setUp."

	^ 'samplePlain
	^ 42'
]

{ #category : 'samples' }
PulsarFFIModelTest >> setUp [

	super setUp.
	self class compile: self sampleFFISource classified: #samples.
	self class compile: self samplePlainSource classified: #samples.
	self class compile: self sampleMultiSource classified: #samples
]

{ #category : 'tests' }
PulsarFFIModelTest >> testFfiTextStripsParens [

	| model |
	model := self newModel.
	self assert: model ffiText equals: 'int my_c_function (self, int value)'
]

{ #category : 'tests' }
PulsarFFIModelTest >> testIsFFICall [

	self assert: self newModel ffiCallArrayNode notNil.
	self assert: (PulsarFFIModel newEnvironment: nil entity: self class >> #samplePlain) ffiCallArrayNode isNil
]

{ #category : 'tests' }
PulsarFFIModelTest >> testMultiLineRoundTripUnchanged [

	| model |
	model := self newMultiModel.
	self assert: (model newSourceFor: model ffiText) equals: (self class >> #sampleFFIMulti) sourceCode
]

{ #category : 'tests' }
PulsarFFIModelTest >> testRoundTripUnchanged [

	| model |
	model := self newModel.
	self assert: (model newSourceFor: model ffiText) equals: (self class >> #sampleFFICall:) sourceCode
]

{ #category : 'tests' }
PulsarFFIModelTest >> testUpdateSplicesArrayOnly [
	"Editing the signature must recompile the method, changing only the array and preserving the selector."

	| model source |
	model := self newModel.
	self assert: (model updateWith: 'int my_c_function (self, long value)').
	source := (self class >> #sampleFFICall:) sourceCode.
	self assert: (source includesSubstring: 'self ffiCall:').
	self assert: (source includesSubstring: 'long value').
	self deny: (source includesSubstring: 'int value').
	self assert: self newModel ffiCallArrayNode notNil
]
