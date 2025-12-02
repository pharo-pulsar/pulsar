Class {
	#name : 'DockInstanceFlagModel',
	#superclass : 'DockFlagModel',
	#instVars : [
		'tag'
	],
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'private' }
DockInstanceFlagModel class >> isNodeMatching: aNode argument: aValue [

	^ aValue isSymbol not 
		and: [ aValue isString not ]
]

{ #category : 'initialization' }
DockInstanceFlagModel >> initializeWith: aNode [

	super initializeWith: aNode.
	self tag: aNode arguments first value asString.
	aNode hasComments
		ifTrue: [ self message: (' ' join: aNode comments) ]
]

{ #category : 'accessing' }
DockInstanceFlagModel >> name [

	^ self tag
]

{ #category : 'printing' }
DockInstanceFlagModel >> printOn: stream [

	super printOn: stream.
	stream << '(' << self tag << ')'
]

{ #category : 'accessing' }
DockInstanceFlagModel >> tag [

	^ tag
]

{ #category : 'initialization' }
DockInstanceFlagModel >> tag: aString [

	tag := aString
]
