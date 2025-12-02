Class {
	#name : 'DockStringFlagModel',
	#superclass : 'DockFlagModel',
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'private' }
DockStringFlagModel class >> isNodeMatching: aNode argument: aValue [

	^ aValue isSymbol not and: [ aValue isString ]
]

{ #category : 'initialization' }
DockStringFlagModel >> initializeWith: aNode [

	super initializeWith: aNode.
	self message: (' ' join: aNode arguments first value lines) withSeparatorsCompacted
]

{ #category : 'accessing' }
DockStringFlagModel >> name [

	^ 'MESSAGE'
]

{ #category : 'printing' }
DockStringFlagModel >> printOn: stream [

	super printOn: stream.
	stream << '(' << self message << ')'
]
