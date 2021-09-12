Class {
	#name : #StBrowserHierarchyNode,
	#superclass : #Object,
	#instVars : [
		'element',
		'children',
		'parent'
	],
	#category : #'NewTools-Browser-Model'
}

{ #category : #'instance creation' }
StBrowserHierarchyNode class >> for: anObject [

	^ self new 
		element: anObject;
		yourself
]

{ #category : #accessing }
StBrowserHierarchyNode >> addChildNode: aNode [

	children ifNil: [ children := OrderedCollection new: 2 ].
	aNode parent: self.
	children add: aNode
]

{ #category : #accessing }
StBrowserHierarchyNode >> children [

	^ children ifNil: [ #() ]
]

{ #category : #accessing }
StBrowserHierarchyNode >> element [

	^ element
]

{ #category : #accessing }
StBrowserHierarchyNode >> element: anObject [

	element := anObject
]

{ #category : #'as yet unclassified' }
StBrowserHierarchyNode >> findParentFrom: nodes [
	| parents |

	parent ifNotNil: [ ^ self ].
	
	parents := nodes select: [ :each | 
		each ~= self and: [ self element inheritsFrom: each element ] ].
	parents ifEmpty: [ ^ self ].
	
	parents size = 1 ifTrue: [ 
		parents first addChildNode: self.
		^ self ].
	
	"sort and find"
	(((StBrowserHierarchyBuilder buildFromNodes: parents) 
		flatCollect: [ :each | each withChildren ])
		reversed 
		detect: [ :each | (self element inheritsFrom: each element) ])
		addChildNode: self
		
]

{ #category : #testing }
StBrowserHierarchyNode >> hasChildren [

	^ children isEmptyOrNil not
]

{ #category : #testing }
StBrowserHierarchyNode >> hasParent [

	^ parent notNil
]

{ #category : #accessing }
StBrowserHierarchyNode >> icon [
	
	^ self element icon
]

{ #category : #accessing }
StBrowserHierarchyNode >> name [
	
	^ self element name
]

{ #category : #accessing }
StBrowserHierarchyNode >> parent [

	^ parent
]

{ #category : #accessing }
StBrowserHierarchyNode >> parent: aNode [

	parent := aNode
]

{ #category : #printing }
StBrowserHierarchyNode >> printOn: stream [

	super printOn: stream.
	stream << '(' << self name << ')'
]

{ #category : #accessing }
StBrowserHierarchyNode >> withChildren [ 

	^ self children copyWithFirst: self
]
