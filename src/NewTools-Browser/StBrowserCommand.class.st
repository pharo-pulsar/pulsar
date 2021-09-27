Class {
	#name : #StBrowserCommand,
	#superclass : #StCommand,
	#category : #'NewTools-Browser-Commands'
}

{ #category : #accessing }
StBrowserCommand class >> allCommands [

	^ self allSubclasses sorted: [ :a | a priority ] ascending
]

{ #category : #accessing }
StBrowserCommand class >> allCommandsSuchAs: aBlock [

	^ self allCommands select: aBlock
]

{ #category : #accessing }
StBrowserCommand class >> priority [

	^ 0
]

{ #category : #testing }
StBrowserCommand class >> showInToolbar [

	^ false
]
