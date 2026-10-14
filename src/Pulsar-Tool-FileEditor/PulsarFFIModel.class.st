"
I am the model backing the FFI editor tab. I expose the C-style signature of a simple ffiCall: method and recompile the method when the signature is edited.

I extract the literal-array spec from the method source and edit it in place, so the rest of the method (selector, options and formatting) is preserved.
"
Class {
	#name : 'PulsarFFIModel',
	#superclass : 'PvMethodModel',
	#instVars : [
		'originalSource',
		'arraySpan',
		'ffiText'
	],
	#category : 'Pulsar-Tool-FileEditor',
	#package : 'Pulsar-Tool-FileEditor'
}

{ #category : 'private' }
PulsarFFIModel >> ensureExtracted [
	"Extract the ffi array source span and its C-style text from the current method entity."

	| node spanText |
	originalSource := self entity sourceCode.
	node := self ffiCallArrayNode.
	node ifNil: [
			arraySpan := nil.
			ffiText := ''.
			^ self ].
	arraySpan := node start -> node stop.
	spanText := originalSource copyFrom: node start to: node stop.
	ffiText := spanText copyFrom: 3 to: spanText size - 1
]

{ #category : 'accessing' }
PulsarFFIModel >> ffiText [
	"Answer the C-style signature text (the ffi array without its outer #() prefix and closing parenthesis)."

	self entity sourceCode = originalSource ifFalse: [ self ensureExtracted ].
	^ ffiText
]

{ #category : 'updating' }
PulsarFFIModel >> newSourceFor: aCString [
	"Answer the method source obtained by replacing the original ffi array text with the given C-style signature wrapped in #()."

	| arrayText |
	self ffiText. "ensure extracted"
	arraySpan ifNil: [ self error: 'Method has no ffi call' ].
	arrayText := '#(' , aCString , ')'.
	^ (originalSource copyFrom: 1 to: arraySpan key - 1) , arrayText
	  , (originalSource copyFrom: arraySpan value + 1 to: originalSource size)
]

{ #category : 'accessing' }
PulsarFFIModel >> pulsarEditorClass [

	^ PulsarFFIEditor
]

{ #category : 'updating' }
PulsarFFIModel >> updateWith: aCString [
	"Compile the method with the given C-style signature. Answer a boolean indicating success."

	^ self updateWith: (self newSourceFor: aCString) notifying: (SpCodeMethodInteractionModel on: self entity)
]

{ #category : 'accessing' }
PulsarFFIModel >> windowTitle [

	^ 'FFI'
]
