"
Encapsulates the result of a test run in the Pulsar test runner.

It holds the full suite collection, summary counts, and pre-built tree nodes ready for display.
Created by PulsarTestRunnerModel after running tests and announcing via PulsarTestRunFinished.
"
Class {
	#name : 'PulsarTestRunnerResult',
	#superclass : 'PvBaseModel',
	#instVars : [
		'suites',
		'passCount',
		'failCount',
		'errorCount',
		'resultNodes'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarTestRunnerResult class >> fromTestRunnerModel: aTestRunnerModel [

	^ self new initializeWithModel: aTestRunnerModel suites: aTestRunnerModel suites caseFilter: nil
]

{ #category : 'instance creation' }
PulsarTestRunnerResult class >> fromTestRunnerModel: aTestRunnerModel case: aCase [

	^ self new initializeWithModel: aTestRunnerModel suites: { aCase parentModel } caseFilter: [ :each | each = aCase ]
]

{ #category : 'instance creation' }
PulsarTestRunnerResult class >> fromTestRunnerModel: aTestRunnerModel suite: aSuite [

	^ self new initializeWithModel: aTestRunnerModel suites: { aSuite } caseFilter: nil
]

{ #category : 'private' }
PulsarTestRunnerResult >> buildGroupNode: aSuite for: caseCollection label: aLabel [
	"Build a tree node for a group of cases from the same suite."

	| groupNode |
	groupNode := PvTreeNodeModel new
		             name: ('{1} - {2} ({3})' format: {
						              aSuite name.
						              aLabel.
						              caseCollection size });
		             iconName: #testNotRun;
		             children: OrderedCollection new;
		             yourself.
	caseCollection do: [ :eachCase |
			| methodNode |
			methodNode := PvTreeNodeModel new
				              name: eachCase testSelector;
				              iconName: eachCase iconName;
				              realModel: eachCase;
				              children: #(  );
				              yourself.
			groupNode children add: methodNode ].
	^ groupNode
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> errorCount [

	^ errorCount
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> failCount [

	^ failCount
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> iconName [

	errorCount > 0 ifTrue: [ ^ 'run-test-error' ].
	failCount > 0 ifTrue: [ ^ 'run-test-failure' ].
	passCount > 0 ifTrue: [ ^ 'run-test-passed' ].
	^ 'test-not-run'
]

{ #category : 'private' }
PulsarTestRunnerResult >> initializeWithModel: aTestRunnerModel suites: aSuiteCollection caseFilter: aCaseFilter [

	| failureNodes errorNodes passedNodes |
	self
		environmentModel: aTestRunnerModel environmentModel;
		entity: aTestRunnerModel entity.

	passCount := 0.
	failCount := 0.
	errorCount := 0.
	failureNodes := OrderedCollection new.
	errorNodes := OrderedCollection new.
	passedNodes := OrderedCollection new.
	suites := aSuiteCollection.

	suites do: [ :eachSuite |
			| children failureCases errorCases passedCases |
			children := aCaseFilter ifNotNil: [ eachSuite children select: aCaseFilter ] ifNil: [ eachSuite children ].
			failureCases := children select: [ :each | each result = #failure ].
			errorCases := children select: [ :each | each result = #error ].
			passedCases := children select: [ :each | each result isNil ].
			failCount := failCount + failureCases size.
			errorCount := errorCount + errorCases size.
			passCount := passCount + passedCases size.
			failureCases ifNotEmpty: [ failureNodes add: (self buildGroupNode: eachSuite for: failureCases label: 'Failures') ].
			errorCases ifNotEmpty: [ errorNodes add: (self buildGroupNode: eachSuite for: errorCases label: 'Errors') ].
			passedCases ifNotEmpty: [ passedNodes add: (self buildGroupNode: eachSuite for: passedCases label: 'Passed') ] ].

	resultNodes := failureNodes , errorNodes , passedNodes
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> name [

	^ 'Test Results: {1}' format: { self entity name }
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> passCount [

	^ passCount
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> resultNodes [

	^ resultNodes
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> suites [

	^ suites
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> suites: anObject [

	suites := anObject
]

{ #category : 'accessing' }
PulsarTestRunnerResult >> summary [

	^ '{1} passed, {2} failures, {3} errors' format: {
			  passCount.
			  failCount.
			  errorCount }
]
