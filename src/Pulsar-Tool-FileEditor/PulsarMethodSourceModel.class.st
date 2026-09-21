Class {
	#name : 'PulsarMethodSourceModel',
	#superclass : 'PvMethodModel',
	#category : 'Pulsar-Tool-FileEditor-Model',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Model'
}

{ #category : 'testing' }
PulsarMethodSourceModel >> fileExists [

	^ true
]

{ #category : 'testing' }
PulsarMethodSourceModel >> isSmalltalk [

	self pragma arguments first = 'smalltalk'.
	
	^ false.
]

{ #category : 'private' }
PulsarMethodSourceModel >> pragma [

	^ self entity pragmaAt: #pulsarSourceEditor:
]

{ #category : 'accessing - ui' }
PulsarMethodSourceModel >> pulsarEditorClass [

	^ PulsarMethodSourceEditor
]

{ #category : 'accessing' }
PulsarMethodSourceModel >> sourceCode [
	
	^ self entity literals 
		detect: [ :each | each isString ]
		ifNone: [ '' ]
]

{ #category : 'accessing' }
PulsarMethodSourceModel >> sourceCodeLanguage [

	^ self pragma arguments first
]

{ #category : 'updating' }
PulsarMethodSourceModel >> updateWith: aString [

	self 
		updateWith: f'[self selector]
	<pulsarSourceEditor: ''[self sourceCodeLanguage]''>

	^ ''[aString escapeCharacter: $']'''
		notifying: (SpCodeMethodInteractionModel on: self entity).
		
	^ true
]

{ #category : 'accessing' }
PulsarMethodSourceModel >> windowTitle [

	^ self pragma arguments first capitalized
]
