Class {
	#name : 'DockSymbolFlagModel',
	#superclass : 'DockFlagModel',
	#instVars : [
		'tag'
	],
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'private' }
DockSymbolFlagModel class >> isNodeMatching: aNode argument: aValue [

	^ aValue isSymbol
]

{ #category : 'initialization' }
DockSymbolFlagModel >> initializeWith: aNode [

	super initializeWith: aNode.
	self tag: aNode arguments first value.
	aNode hasComments ifTrue: [ 
		self message: (' ' join: (aNode comments flatCollect: [ :each | each contents lines ])) withSeparatorsCompacted ]
]

{ #category : 'accessing' }
DockSymbolFlagModel >> name [

	^ self tag
]

{ #category : 'printing' }
DockSymbolFlagModel >> printOn: stream [

	super printOn: stream.
	stream << '(' << self tag << ')'
]

{ #category : 'accessing' }
DockSymbolFlagModel >> tag [

	^ tag
]

{ #category : 'initialization' }
DockSymbolFlagModel >> tag: aSymbol [

	tag := aSymbol
]
