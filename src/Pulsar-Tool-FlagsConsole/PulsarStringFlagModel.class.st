Class {
	#name : 'PulsarStringFlagModel',
	#superclass : 'PulsarFlagModel',
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'private' }
PulsarStringFlagModel class >> isNodeMatching: aNode argument: aValue [

	^ aValue isSymbol not and: [ aValue isString ]
]

{ #category : 'initialization' }
PulsarStringFlagModel >> initializeWith: aNode [

	super initializeWith: aNode.
	self message: (' ' join: aNode arguments first value lines) withSeparatorsCompacted
]

{ #category : 'accessing' }
PulsarStringFlagModel >> name [

	^ 'MESSAGE'
]

{ #category : 'printing' }
PulsarStringFlagModel >> printOn: stream [

	super printOn: stream.
	stream << '(' << self message << ')'
]
