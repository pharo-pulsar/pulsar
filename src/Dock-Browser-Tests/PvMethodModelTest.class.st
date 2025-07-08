Class {
	#name : 'PvMethodModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'tests' }
PvMethodModelTest >> testActionDecoratorsIncludeTestIfTestMethod [
	| model |

	"I use myself as test method"
	model := PvMethodModel 
		newEnvironment: nil
		entity: self class >> #testActionDecoratorsIncludeTestIfTestMethod.
		
	self assert: (model actionDecorators 
		anySatisfy: [ :each | each class = DockMethodActionRunTestDecorator ])
]

{ #category : 'tests' }
PvMethodModelTest >> testRunTestUpdatesPropertyCache [
	| model result resultTest |

	"I use a sibling test as test method"
	model := PvMethodModel 
		newEnvironment: nil
		entity: self class >> #testActionDecoratorsIncludeTestIfTestMethod.

	model runTest.
		
	result := TestResult fromTestCaseHistory: model entity methodClass.
	resultTest := result tests 
		detect: [ :each | each selector = model entity selector ]
		ifNone: [ nil ].
	
	self assert: resultTest isNotNil
]
