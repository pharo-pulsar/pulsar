"
Model for the PulsarTestRunnerBrowser, wrapping a PulsarBaseProjectModel as its entity.

Builds the test tree from the project's packages, manages test selection and execution, and stores the last test run result.
"
Class {
	#name : 'PulsarTestRunnerModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'testTreeRoot',
		'lastResult',
		'mutex'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'tree building' }
PulsarTestRunnerModel >> buildTestTree [

	testTreeRoot := PulsarTestProjectNode newEntity: self projectModel parent: nil model: self.
	testTreeRoot selectAll.
	^ testTreeRoot
]

{ #category : 'initialization' }
PulsarTestRunnerModel >> initialize [

	super initialize.
	mutex := Mutex new
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> lastResult [

	^ lastResult
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> lastResult: anObject [

	lastResult := anObject
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> mutex [

	^ mutex
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> mutex: anObject [

	mutex := anObject
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> name [

	^ 'Tests: {1}' format: { self projectModel name }
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> projectModel [

	^ self entity
]

{ #category : 'tree building' }
PulsarTestRunnerModel >> refresh [

	testTreeRoot := nil.
	self buildTestTree
]

{ #category : 'running' }
PulsarTestRunnerModel >> runAllTests [
	"Run all tests synchronously and return the result."

	| result |
	testTreeRoot ifNil: [ self buildTestTree ].
	result := NewTestRunner runSuite: self suiteFromAllTests.
	^ self storeAndReturnResult: result
]

{ #category : 'running' }
PulsarTestRunnerModel >> runSelectedTests [
	"Run selected tests synchronously and return the result."

	| methods result |
	methods := self selectedTestMethods.
	methods ifEmpty: [ ^ nil ].
	result := NewTestRunner runSuite: (self suiteFromMethods: methods).
	^ self storeAndReturnResult: result
]

{ #category : 'running' }
PulsarTestRunnerModel >> selectedTestMethods [
	"Collect all active test method nodes from the tree."

	testTreeRoot ifNil: [ self buildTestTree ].
	^ testTreeRoot selectedMethodNodes
]

{ #category : 'running' }
PulsarTestRunnerModel >> storeAndReturnResult: aTestResult [
	"Store the test result and return a PulsarTestRunResult."

	lastResult := PulsarTestRunResult fromTestResult: aTestResult.
	^ lastResult
]

{ #category : 'running' }
PulsarTestRunnerModel >> suiteFromAllTests [

	| suite |
	suite := TestSuite named: self name.
	testTreeRoot selectedMethodNodes do: [ :eachNode | suite addTest: (eachNode testClass selector: eachNode testSelector) ].
	^ suite
]

{ #category : 'running' }
PulsarTestRunnerModel >> suiteFromMethods: aMethodNodeCollection [

	| suite |
	suite := TestSuite named: self name.
	aMethodNodeCollection do: [ :eachNode | suite addTest: (eachNode testClass selector: eachNode testSelector) ].
	^ suite
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> testTreeRoot [

	^ testTreeRoot ifNil: [ testTreeRoot := self buildTestTree ]
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> testTreeRoot: anObject [

	testTreeRoot := anObject
]
