Class {
	#name : 'PulsarSymbolFlagModel',
	#superclass : 'PulsarFlagModel',
	#instVars : [
		'tag'
	],
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'private' }
PulsarSymbolFlagModel class >> isNodeMatching: aNode argument: aValue [

	^ aValue isSymbol
]

{ #category : 'initialization' }
PulsarSymbolFlagModel >> initializeWith: aNode [

	super initializeWith: aNode.
	self tag: aNode arguments first value.
	aNode hasComments ifTrue: [ 
		self message: (' ' join: (aNode comments flatCollect: [ :each | each contents lines ])) withSeparatorsCompacted ]
]

{ #category : 'accessing' }
PulsarSymbolFlagModel >> name [

	^ self tag
]

{ #category : 'printing' }
PulsarSymbolFlagModel >> printOn: stream [

	super printOn: stream.
	stream << '(' << self tag << ')'
]

{ #category : 'accessing' }
PulsarSymbolFlagModel >> tag [

	^ tag
]

{ #category : 'initialization' }
PulsarSymbolFlagModel >> tag: aSymbol [

	tag := aSymbol
]
