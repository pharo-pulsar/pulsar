"
A generic node to be used to add nodes to a tree.
"
Class {
	#name : 'PvTreeNodeModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'name',
		'children',
		'iconName'
	],
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvTreeNodeModel class >> newName: aName children: aCollection [

	^ self new 
		name: aName;
		children: aCollection;
		yourself
]

{ #category : 'instance creation' }
PvTreeNodeModel class >> newName: aName iconName: anIconName children: aCollection [

	^ self new 
		name: aName;
		iconName: anIconName;
		children: aCollection;
		yourself
]

{ #category : 'testing' }
PvTreeNodeModel >> canBeRemoved [

	^ false
]

{ #category : 'testing' }
PvTreeNodeModel >> canBeRenamed [

	^ false
]

{ #category : 'accessing' }
PvTreeNodeModel >> children [

	^ children
]

{ #category : 'accessing' }
PvTreeNodeModel >> children: aCollection [

	children := aCollection
]

{ #category : 'accessing' }
PvTreeNodeModel >> iconName [

	^ iconName
]

{ #category : 'accessing' }
PvTreeNodeModel >> iconName: aName [

	iconName := aName
]

{ #category : 'accessing' }
PvTreeNodeModel >> name [

	^ name
]

{ #category : 'accessing' }
PvTreeNodeModel >> name: aString [

	name := aString
]
