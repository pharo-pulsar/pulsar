"
A node to traverse (and cherry pick) the diff tree.
"
Class {
	#name : 'DockDiffNode',
	#superclass : 'Object',
	#instVars : [
		'node',
		'children'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'instance creation' }
DockDiffNode class >> on: aNode [

	^ self new 
		node: aNode;
		yourself
]

{ #category : 'accessing' }
DockDiffNode >> children [

	^ children ifNil: [ children := self collectChildren ]
]

{ #category : 'private' }
DockDiffNode >> collectChildren [

	^ self node children collect: [ :each | DockDiffNode on: each ]
]

{ #category : 'accessing' }
DockDiffNode >> description [

	^ self node value description asString
]

{ #category : 'accessing' }
DockDiffNode >> iconName [

	^ self node value iconName
]

{ #category : 'accessing' }
DockDiffNode >> node [

	^ node
]

{ #category : 'initialization' }
DockDiffNode >> node: aNode [ 

	node := aNode
]
