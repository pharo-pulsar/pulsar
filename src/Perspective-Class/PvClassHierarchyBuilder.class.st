Class {
	#name : 'PvClassHierarchyBuilder',
	#superclass : 'Object',
	#category : 'Perspective-Class',
	#package : 'Perspective-Class'
}

{ #category : 'building' }
PvClassHierarchyBuilder class >> buildFrom: aCollection [

	^ self new buildFrom: aCollection
]

{ #category : 'private' }
PvClassHierarchyBuilder class >> buildFromNodes: aCollection [

	^ self new buildFromNodes: aCollection
]

{ #category : 'building' }
PvClassHierarchyBuilder >> buildFrom: aCollection [

	^ self buildFromNodes: (aCollection collect: [ :each | StBrowserHierarchyNode for: each ])
]

{ #category : 'private' }
PvClassHierarchyBuilder >> buildFromNodes: nodes [

	nodes do: [ :each | each findParentFrom: nodes ].
	^ nodes reject: [ :each | each hasParent ]
]
