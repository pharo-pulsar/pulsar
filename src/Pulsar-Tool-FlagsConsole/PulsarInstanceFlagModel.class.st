Class {
	#name : 'PulsarInstanceFlagModel',
	#superclass : 'PulsarFlagModel',
	#instVars : [
		'tag'
	],
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'private' }
PulsarInstanceFlagModel class >> isNodeMatching: aNode argument: aValue [

	^ aValue isSymbol not 
		and: [ aValue isString not ]
]

{ #category : 'initialization' }
PulsarInstanceFlagModel >> initializeWith: aNode [

	super initializeWith: aNode.
	self tag: aNode arguments first value asString.
	aNode hasComments
		ifTrue: [ self message: (' ' join: aNode comments) ]
]

{ #category : 'accessing' }
PulsarInstanceFlagModel >> name [

	^ self tag
]

{ #category : 'printing' }
PulsarInstanceFlagModel >> printOn: stream [

	super printOn: stream.
	stream << '(' << self tag << ')'
]

{ #category : 'accessing' }
PulsarInstanceFlagModel >> tag [

	^ tag
]

{ #category : 'initialization' }
PulsarInstanceFlagModel >> tag: aString [

	tag := aString
]
