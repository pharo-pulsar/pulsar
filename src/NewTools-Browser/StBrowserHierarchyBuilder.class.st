"
Sort hierarchically a collection of classes.
The method `StBrowserHierarchyBuilder>>#buildFrom:` creates a tree of `StBrowserHierarchyNode` instances.
"
Class {
	#name : #StBrowserHierarchyBuilder,
	#superclass : #Object,
	#category : #'NewTools-Browser-Model-Hierarchy'
}

{ #category : #building }
StBrowserHierarchyBuilder class >> buildFrom: aCollection [

	^ self new buildFrom: aCollection
]

{ #category : #private }
StBrowserHierarchyBuilder class >> buildFromNodes: aCollection [

	^ self new buildFromNodes: aCollection
]

{ #category : #building }
StBrowserHierarchyBuilder >> buildFrom: aCollection [

	^ self buildFromNodes: (aCollection collect: [ :each | StBrowserHierarchyNode for: each ])
]

{ #category : #private }
StBrowserHierarchyBuilder >> buildFromNodes: nodes [

	nodes do: [ :each | each findParentFrom: nodes ].
	^ nodes reject: [ :each | each hasParent ]
]
