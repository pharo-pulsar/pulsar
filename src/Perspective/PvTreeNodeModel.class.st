"
A generic node to be used to add nodes to a tree.
"
Class {
	#name : 'PvTreeNodeModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'name',
		'children',
		'iconName',
		'realModel'
	],
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvTreeNodeModel class >> newModel: aModel name: aName children: aCollection [

	^ self new 
		name: aName;
		children: aCollection;
		realModel: aModel;
		yourself
]

{ #category : 'instance creation' }
PvTreeNodeModel class >> newModel: aModel name: aName iconName: anIconName children: aCollection [

	^ self new 
		name: aName;
		iconName: anIconName;
		children: aCollection;
		realModel: aModel;
		yourself
]

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

{ #category : 'accessing' }
PvTreeNodeModel >> realModel [

	^ realModel ifNil: [ super realModel ]
]

{ #category : 'accessing' }
PvTreeNodeModel >> realModel: aModel [

	realModel := aModel
]
