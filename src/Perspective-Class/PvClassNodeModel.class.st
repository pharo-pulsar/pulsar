Class {
	#name : #PvClassNodeModel,
	#superclass : #PvClassModel,
	#instVars : [
		'child'
	],
	#category : #'Perspective-Class-Model'
}

{ #category : #accessing }
PvClassNodeModel >> child [

	^ child
]

{ #category : #accessing }
PvClassNodeModel >> child: anObject [

	child := anObject
]

{ #category : #accessing }
PvClassNodeModel >> children [

	^ { self child }
]

{ #category : #'accessing - navigating' }
PvClassNodeModel >> subclassesModels [

	^ self children
]
