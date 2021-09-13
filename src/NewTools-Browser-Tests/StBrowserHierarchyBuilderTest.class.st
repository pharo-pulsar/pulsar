Class {
	#name : #StBrowserHierarchyBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'window'
	],
	#category : #'NewTools-Browser-Tests'
}

{ #category : #asserting }
StBrowserHierarchyBuilderTest >> assertNode: aCollection element: aClass children: anObject [
	
	self 
		assertCollection: ((aCollection 
			detect: [ :each | each element = aClass ]) children	 
			collect: #element)
		hasSameElements: anObject
]

{ #category : #asserting }
StBrowserHierarchyBuilderTest >> assertNode: aCollection element: aClass parent: anObject [
	
	self 
		assert: ((aCollection detect: [ :each | each element = aClass ]) parent ifNotNil: #element)	
		equals: anObject
		
]

{ #category : #tests }
StBrowserHierarchyBuilderTest >> testBuildFrom [
	| nodes |

	nodes := (StBrowserHierarchyBuilder new 
		buildFrom: { ProtoObject. Object. Boolean. True. False. UndefinedObject })
		first
		withAllChildren.

	self assertNode: nodes element: ProtoObject parent: nil.
	self assertNode: nodes element: ProtoObject children: { Object }.

	self assertNode: nodes element: Object parent: ProtoObject.
	self assertNode: nodes element: Object children: { Boolean. UndefinedObject }.

	self assertNode: nodes element: Boolean parent: Object.
	self assertNode: nodes element: Boolean children: { True. False }.

	self assertNode: nodes element: True parent: Boolean.
	self assertNode: nodes element: True children: #().

	self assertNode: nodes element: False parent: Boolean.
	self assertNode: nodes element: False children: #().
	
	self assertNode: nodes element: UndefinedObject parent: Object.
	self assertNode: nodes element: UndefinedObject children: #().

]

{ #category : #tests }
StBrowserHierarchyBuilderTest >> testBuildFromWithClassModel [
	| nodes protoObjectModel objectModel booleanModel trueModel falseModel undefinedObjectModel |

	protoObjectModel := StClassModel newClass: ProtoObject.
	objectModel  := StClassModel newClass: Object. 
	booleanModel := StClassModel newClass: Boolean. 
	trueModel := StClassModel newClass: True.
	falseModel := StClassModel newClass: False. 
	undefinedObjectModel := StClassModel newClass: UndefinedObject. 

	nodes := (StBrowserHierarchyBuilder new 
		buildFrom: { protoObjectModel. objectModel. booleanModel. trueModel. falseModel. undefinedObjectModel })
		first
		withAllChildren.

	self assertNode: nodes element: protoObjectModel parent: nil.
	self assertNode: nodes element: protoObjectModel children: { objectModel }.

	self assertNode: nodes element: objectModel parent: protoObjectModel.
	self assertNode: nodes element: objectModel children: { booleanModel. undefinedObjectModel }.

	self assertNode: nodes element: booleanModel parent: objectModel.
	self assertNode: nodes element: booleanModel children: { trueModel. falseModel }.

	self assertNode: nodes element: trueModel parent: booleanModel.
	self assertNode: nodes element: trueModel children: #().

	self assertNode: nodes element: falseModel parent: booleanModel.
	self assertNode: nodes element: falseModel children: #().
	
	self assertNode: nodes element: undefinedObjectModel parent: objectModel.
	self assertNode: nodes element: undefinedObjectModel children: #().

]
