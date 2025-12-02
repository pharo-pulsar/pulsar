Class {
	#name : 'DockFlagModel',
	#superclass : 'Object',
	#instVars : [
		'message',
		'location'
	],
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'private' }
DockFlagModel class >> flagClassFor: aNode [
	| nodeArgument |

	nodeArgument := aNode arguments first value.
	^ self subclasses 
		detect: [ :each | each isNodeMatching: aNode argument: nodeArgument ]
]

{ #category : 'instance creation' }
DockFlagModel class >> fromNode: aNode [

	^ (self flagClassFor: aNode) basicNew
		initializeWith: aNode;
		yourself
]

{ #category : 'private' }
DockFlagModel class >> isNodeMatching: aNode argument: aValue [

	^ false
]

{ #category : 'initialization' }
DockFlagModel >> initializeWith: aNode [

	self initialize.
	self location: aNode
]

{ #category : 'accessing' }
DockFlagModel >> location [

	^ location
]

{ #category : 'initialization' }
DockFlagModel >> location: aNode [
	| methodNode |
	
	methodNode := aNode methodNode.
	location := { methodNode methodClass. methodNode selector. aNode sourceInterval }
]

{ #category : 'accessing' }
DockFlagModel >> locationDescription [

	^ self location first name, '>>', self location second
]

{ #category : 'accessing' }
DockFlagModel >> locationDescriptionSelector [

	^ self location second
]

{ #category : 'private' }
DockFlagModel >> locationMethod [

	^ self location first >> self location second asSymbol
]

{ #category : 'accessing' }
DockFlagModel >> message [

	^ message ifNil: [ '' ]
]

{ #category : 'initialization' }
DockFlagModel >> message: aString [

	message := aString
]

{ #category : 'accessing' }
DockFlagModel >> name [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DockFlagModel >> selection [

	^ self location third
]
