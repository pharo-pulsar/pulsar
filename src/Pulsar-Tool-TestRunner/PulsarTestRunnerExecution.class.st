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
		'notificationCenter',
		'testResult',
		'startTimes'
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

	errorCount > 0 ifTrue: [ ^ 'testResultError' ].
	failCount > 0 ifTrue: [ ^ 'testResultFailure' ].
	passCount > 0 ifTrue: [ ^ 'testResultPass' ].
	^ 'test-not-run'
]

{ #category : 'accessing' }
PulsarTestRunnerExecution >> iconNameFor: aPulsarTestCase [

	testResult ifNil: [ ^ 'testResults' ].

	(testResult errors includes: aPulsarTestCase entity) ifTrue: [ ^ 'testResultError' ].
	(testResult failures includes: aPulsarTestCase entity) ifTrue: [ ^ 'testResultFailure' ].
	(testResult passed includes: aPulsarTestCase entity) ifTrue: [ ^ 'testResultPass' ].

	^ 'testResults'
]

{ #category : 'private' }
PulsarTestRunnerExecution >> initializeOn: aNotificationCenter fromModel: aTestRunnerModel [

	self
		environmentModel: aTestRunnerModel environmentModel;
		entity: aTestRunnerModel entity.

	notificationCenter := aNotificationCenter.
	suites := aTestRunnerModel suites.
	entries := OrderedCollection new.
	startTimes := Dictionary new.
	passCount := 0.
	failCount := 0.
	errorCount := 0.

	notificationCenter when: TestCaseStarted send: #processTestCaseStarted: to: self.
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

	| testClass selector result pulsarCase startTime |
	testClass := ann testCase class.
	selector := ann testSelector.
	result := ann testResult.
	testResult := result.

	pulsarCase := self findCaseInSuites: testClass selector: selector.
	pulsarCase ifNil: [ ^ self ].

	startTime := startTimes at: testClass name -> selector ifAbsent: [ nil ].
	startTime ifNotNil: [ pulsarCase duration: (DateAndTime now - startTime) asMilliSeconds ].

	(result isPassedFor: testClass selector: selector) ifTrue: [
			pulsarCase result: nil.
			passCount := passCount + 1 ].
	(result isFailureFor: testClass selector: selector) ifTrue: [
			pulsarCase result: #failure.
			failCount := failCount + 1 ].
	(result isErrorFor: testClass selector: selector) ifTrue: [
			pulsarCase result: #error.
			errorCount := errorCount + 1 ].

	entries add: pulsarCase.
	notificationCenter announce: (PulsarTestExecutionChanged newValue: self)
]

{ #category : 'events' }
PulsarTestRunnerExecution >> processTestCaseStarted: ann [

	startTimes at: ann testCase class name -> ann testSelector put: DateAndTime now
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

{ #category : 'accessing' }
PulsarTestRunnerExecution >> testResult [

	^ testResult
]
