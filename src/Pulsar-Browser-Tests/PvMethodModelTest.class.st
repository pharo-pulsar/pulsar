Class {
	#name : 'PvMethodModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'tests' }
PvMethodModelTest >> testActionDecoratorsIncludeTestIfTestMethod [
	| model |

	"I use myself as test method"
	model := PvMethodModel 
		newEnvironment: nil
		entity: self class >> #testActionDecoratorsIncludeTestIfTestMethod.
		
	self assert: (model actionDecorators 
		anySatisfy: [ :each | each class = PulsarMethodActionRunTestDecorator ])
]

{ #category : 'tests' }
PvMethodModelTest >> testHierarchyTopModelForClassSide [
	| model topModel |

	model := PvMethodModel 
		newEnvironment: nil
		entity: Collection class>>#newFromArray:.
	
	topModel := model hierarchyTopModel.
	
	self assert: topModel entity equals: Object class>>#newFromArray:.
	self denyEmpty: topModel children.
	self assert: topModel entity first equals: Collection class>>#newFromArray:
]

{ #category : 'tests' }
PvMethodModelTest >> testRunTestUpdatesPropertyCache [
	| model result resultTest c |

	"I use a sibling test as test method"
	model := PvMethodModel 
		newEnvironment: nil
		entity: self class >> #testActionDecoratorsIncludeTestIfTestMethod.
	c := 0.
	model runTestAnnouncingTo: (Announcer new	
		when: TestCaseEnded do: [ :ann | c := c + 1 ] for: model;
		yourself).
		
	result := TestResult fromTestCaseHistory: model entity methodClass.
	resultTest := result tests 
		detect: [ :each | each selector = model entity selector ]
		ifNone: [ nil ].
	
	self assert: resultTest isNotNil.
	self assert: c equals: 1
]
