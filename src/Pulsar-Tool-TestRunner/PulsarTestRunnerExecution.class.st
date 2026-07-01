"
A live model representing an ongoing test execution in the Pulsar test runner.

It subscribes to TestCaseEnded announcments and accumulates results as they arrive,
providing a streaming view of test progress for the ResultsEditor.
Replaces PulsarTestRunnerResult.
"
Class {
	#name : 'PulsarTestRunnerExecution',
	#superclass : 'PvBaseModel',
	#instVars : [
		'entries',
		'suites',
		'passCount',
		'failCount',
		'errorCount',
		'notificationCenter'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarTestRunnerExecution class >> on: aNotificationCenter fromModel: aTestRunnerModel [

	^ self new initializeOn: aNotificationCenter fromModel: aTestRunnerModel
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> entries [

	^ entries
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> errorCount [

	^ errorCount
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> failCount [

	^ failCount
]

{ #category : 'private' }
PulsarTestRunnerExecution >> findCaseInSuites: aTestClass selector: aSelector [

	suites do: [ :eachSuite |
			eachSuite children do: [ :eachCase |
				(eachCase testClass = aTestClass and: [ eachCase testSelector = aSelector ]) ifTrue: [ ^ eachCase ] ] ].
	^ nil
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> iconName [

	errorCount > 0 ifTrue: [ ^ 'run-test-error' ].
	failCount > 0 ifTrue: [ ^ 'run-test-failure' ].
	passCount > 0 ifTrue: [ ^ 'run-test-passed' ].
	^ 'test-not-run'
]

{ #category : 'private' }
PulsarTestRunnerExecution >> initializeOn: aNotificationCenter fromModel: aTestRunnerModel [

	self
		environmentModel: aTestRunnerModel environmentModel;
		entity: aTestRunnerModel entity.

	notificationCenter := aNotificationCenter.
	suites := aTestRunnerModel suites.
	entries := OrderedCollection new.
	passCount := 0.
	failCount := 0.
	errorCount := 0.

	notificationCenter when: TestCaseEnded send: #processTestCaseEnded: to: self.
	notificationCenter when: TestSuiteEnded send: #processTestSuiteEnded: to: self
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> name [

	^ 'Test Runner Execution: {1}' format: { self entity name }
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> passCount [

	^ passCount
]

{ #category : 'events' }
PulsarTestRunnerExecution >> processTestCaseEnded: ann [

	| testClass selector testResult pulsarCase |
	testClass := ann testCase class.
	selector := ann testSelector.
	testResult := ann testResult.

	pulsarCase := self findCaseInSuites: testClass selector: selector.
	pulsarCase ifNil: [ ^ self ].

	(testResult isPassedFor: testClass selector: selector) ifTrue: [
			pulsarCase result: nil.
			passCount := passCount + 1 ].
	(testResult isFailureFor: testClass selector: selector) ifTrue: [
			pulsarCase result: #failure.
			failCount := failCount + 1 ].
	(testResult isErrorFor: testClass selector: selector) ifTrue: [
			pulsarCase result: #error.
			errorCount := errorCount + 1 ].

	entries add: pulsarCase.
	notificationCenter announce: (PulsarTestExecutionChanged newValue: self)
]

{ #category : 'events' }
PulsarTestRunnerExecution >> processTestSuiteEnded: ann [

	notificationCenter unsubscribe: self
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> suites [

	^ suites
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> summary [

	^ '{1} passed, {2} failures, {3} errors' format: {
			  passCount.
			  failCount.
			  errorCount }
]
