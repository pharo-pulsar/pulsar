"
A generic node to be used to add nodes to a tree.
"
Class {
	#name : #PvEntityTreeNode,
	#superclass : #PvEntityModel,
	#instVars : [
		'name',
		'children',
		'iconName'
	],
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #'instance creation' }
PvEntityTreeNode class >> newName: aName children: aCollection [

	^ self new 
		name: aName;
		children: aCollection;
		yourself
]

{ #category : #'instance creation' }
PvEntityTreeNode class >> newName: aName iconName: anIconName children: aCollection [

	^ self new 
		name: aName;
		iconName: anIconName;
		children: aCollection;
		yourself
]

{ #category : #accessing }
PvEntityTreeNode >> children [

	^ children
]

{ #category : #accessing }
PvEntityTreeNode >> children: aCollection [

	children := aCollection
]

{ #category : #accessing }
PvEntityTreeNode >> iconName [

	^ iconName
]

{ #category : #accessing }
PvEntityTreeNode >> iconName: aName [

	iconName := aName
]

{ #category : #accessing }
PvEntityTreeNode >> name [

	^ name
]

{ #category : #accessing }
PvEntityTreeNode >> name: aString [

	name := aString
]
