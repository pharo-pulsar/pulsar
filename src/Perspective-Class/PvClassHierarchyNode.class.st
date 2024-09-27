Class {
	#name : 'PvClassHierarchyNode',
	#superclass : 'Object',
	#instVars : [
		'element',
		'children',
		'parent'
	],
	#category : 'Perspective-Class',
	#package : 'Perspective-Class'
}

{ #category : 'instance creation' }
PvClassHierarchyNode class >> for: anObject [

	^ self new 
		element: anObject;
		yourself
]

{ #category : 'accessing' }
PvClassHierarchyNode >> addChildNode: aNode [

	children ifNil: [ children := OrderedCollection new: 2 ].
	aNode parent: self.
	children add: aNode
]

{ #category : 'accessing' }
PvClassHierarchyNode >> allChildren [
	self shouldBeImplemented.
]

{ #category : 'accessing' }
PvClassHierarchyNode >> children [

	^ children ifNil: [ #() ]
]

{ #category : 'accessing' }
PvClassHierarchyNode >> element [

	^ element
]

{ #category : 'accessing' }
PvClassHierarchyNode >> element: anObject [

	element := anObject
]

{ #category : 'accessing' }
PvClassHierarchyNode >> findParentFrom: nodes [
	| parents parentNodes |

	parent ifNotNil: [ ^ self ].
	
	parents := nodes select: [ :each | 
		each ~= self and: [ self element inheritsFrom: each element ] ].
	parents ifEmpty: [ ^ self ].
	
	parents size = 1 ifTrue: [ 
		parents first addChildNode: self.
		^ self ].
	
	"sort and find"
	parentNodes := parents sorted: [ :a | a element classDepth ] ascending.
	parentNodes last addChildNode: self
]

{ #category : 'testing' }
PvClassHierarchyNode >> hasChildren [

	^ children isEmptyOrNil not
]

{ #category : 'testing' }
PvClassHierarchyNode >> hasParent [

	^ parent notNil
]

{ #category : 'accessing' }
PvClassHierarchyNode >> iconName [
	
	^ self element iconName
]

{ #category : 'accessing' }
PvClassHierarchyNode >> name [
	
	^ self element name
]

{ #category : 'accessing' }
PvClassHierarchyNode >> parent [

	^ parent
]

{ #category : 'accessing' }
PvClassHierarchyNode >> parent: aNode [

	parent := aNode
]

{ #category : 'printing' }
PvClassHierarchyNode >> printOn: stream [

	super printOn: stream.
	stream << '(' << self name << ')'
]

{ #category : 'accessing' }
PvClassHierarchyNode >> withAllChildren [

	children ifNil: [ ^ { self } ].
	^ { self }, (children flatCollect: [ :each | each withAllChildren ])
]

{ #category : 'accessing' }
PvClassHierarchyNode >> withAllParents [

	self parent ifNil: [ ^ { self } ].
	^ self parent withAllParents, { self }
]

{ #category : 'accessing' }
PvClassHierarchyNode >> withChildren [

	^ self children copyWithFirst: self
]
