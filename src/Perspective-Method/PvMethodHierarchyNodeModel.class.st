Class {
	#name : 'PvMethodHierarchyNodeModel',
	#superclass : 'PvMethodModel',
	#instVars : [
		'parent',
		'children'
	],
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvMethodHierarchyNodeModel >> addChildNode: aNode [

	children ifNil: [ children := OrderedCollection new ].
	aNode parent: self.
	children add: aNode
]

{ #category : 'accessing' }
PvMethodHierarchyNodeModel >> children [

	^ children ifNil: [ #() ]
]

{ #category : 'accessing' }
PvMethodHierarchyNodeModel >> findParentFrom: nodes [
	| parents parentNodes |

	parent ifNotNil: [ ^ self ].
	
	parents := nodes select: [ :each | 
		each ~= self and: [ self entity origin inheritsFrom: each entity origin ] ].
	parents ifEmpty: [ ^ self ].
	
	parents size = 1 ifTrue: [ 
		parents first addChildNode: self.
		^ self ].
	
	"sort and find"
	parentNodes := parents sorted: [ :a | a entity origin classDepth ] ascending.
	parentNodes last addChildNode: self
]

{ #category : 'accessing' }
PvMethodHierarchyNodeModel >> parent [

	^ parent
]

{ #category : 'accessing' }
PvMethodHierarchyNodeModel >> parent: aNode [

	parent := aNode
]

{ #category : 'private' }
PvMethodHierarchyNodeModel >> species [

	^ PvMethodModel
]
