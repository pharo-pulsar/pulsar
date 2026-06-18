Class {
	#name : 'PulsarFlagModel',
	#superclass : 'Object',
	#instVars : [
		'message',
		'location'
	],
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'private' }
PulsarFlagModel class >> flagClassFor: aNode [
	| nodeArgument |

	nodeArgument := aNode arguments first value.
	^ self subclasses 
		detect: [ :each | each isNodeMatching: aNode argument: nodeArgument ]
]

{ #category : 'instance creation' }
PulsarFlagModel class >> fromNode: aNode [

	^ (self flagClassFor: aNode) basicNew
		initializeWith: aNode;
		yourself
]

{ #category : 'private' }
PulsarFlagModel class >> isNodeMatching: aNode argument: aValue [

	^ false
]

{ #category : 'initialization' }
PulsarFlagModel >> initializeWith: aNode [

	self initialize.
	self location: aNode
]

{ #category : 'accessing' }
PulsarFlagModel >> location [

	^ location
]

{ #category : 'initialization' }
PulsarFlagModel >> location: aNode [
	| methodNode |
	
	methodNode := aNode methodNode.
	location := { 
		methodNode methodClass. 
		methodNode selector. 
		aNode sourceInterval first to:  aNode sourceInterval stop + 1}
]

{ #category : 'accessing' }
PulsarFlagModel >> locationDescription [

	^ self location first name, '>>', self location second
]

{ #category : 'accessing' }
PulsarFlagModel >> locationDescriptionSelector [

	^ self location second
]

{ #category : 'private' }
PulsarFlagModel >> locationMethod [

	^ self location first >> self location second asSymbol
]

{ #category : 'accessing' }
PulsarFlagModel >> message [

	^ message ifNil: [ '' ]
]

{ #category : 'initialization' }
PulsarFlagModel >> message: aString [

	message := aString
]

{ #category : 'accessing' }
PulsarFlagModel >> name [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarFlagModel >> selection [

	^ self location third
]
