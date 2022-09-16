Class {
	#name : #PvClassHierarchyNodeModel,
	#superclass : #PvClassModel,
	#instVars : [
		'children',
		'childrenNodeProvider'
	],
	#category : #'Perspective-Class-Model'
}

{ #category : #accessing }
PvClassHierarchyNodeModel >> child [

	^ self children first
]

{ #category : #accessing }
PvClassHierarchyNodeModel >> child: anObject [

	self children: { anObject }
]

{ #category : #accessing }
PvClassHierarchyNodeModel >> children [

	childrenNodeProvider ifNotNil: [ 
		^ (childrenNodeProvider value: self entity) collect: [ :each | 
			(self class 
					newEnvironment: self environmentModel 
					entity: each)
				childrenNodeProvider: childrenNodeProvider;
				yourself ] ].
	
	^ children ifNil: [ #() ]
]

{ #category : #accessing }
PvClassHierarchyNodeModel >> children: aCollection [

	children := aCollection
]

{ #category : #accessing }
PvClassHierarchyNodeModel >> childrenNodeProvider: aBlock [

	childrenNodeProvider := aBlock
]

{ #category : #private }
PvClassHierarchyNodeModel >> species [

	^ PvClassModel
]
