Class {
	#name : 'PvMethodModelTest',
	#superclass : 'TestCase',
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
	| model timeStampBeforeRun result |

	"I use a sibling test as test method"
	model := PvMethodModel 
		newEnvironment: nil
		entity: self class >> #testActionDecoratorsIncludeTestIfTestMethod.

	model entity removeProperty: #lastTestExecutionResult.
	
	timeStampBeforeRun := DateAndTime now.
	model runTest.
		
	result := model entity propertyAt: #lastTestExecutionResult.
	
	self assert: result isNotNil.
	self assert: result timeStamp >= timeStampBeforeRun
]
