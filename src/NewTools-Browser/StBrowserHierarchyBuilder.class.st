Class {
	#name : #StBrowserHierarchyBuilder,
	#superclass : #Object,
	#category : #'NewTools-Browser-Model'
}

{ #category : #building }
StBrowserHierarchyBuilder class >> buildFrom: aCollection [

	^ self new buildFrom: aCollection
]

{ #category : #building }
StBrowserHierarchyBuilder class >> buildFromNodes: aCollection [

	^ self new buildFromNodes: aCollection
]

{ #category : #building }
StBrowserHierarchyBuilder >> buildFrom: aCollection [

	^ self buildFromNodes: (aCollection collect: [ :each | StBrowserHierarchyNode for: each ])
]

{ #category : #building }
StBrowserHierarchyBuilder >> buildFromNodes: nodes [

	nodes do: [ :each | each findParentFrom: nodes ].
	^ nodes reject: [ :each | each hasParent ]
]
