"
A flat holder for a complete test run result.

Contains four collections of PulsarTestResultItem (passed, failures, errors, skipped) plus a timestamp. Builds the display tree for the results editor view.
"
Class {
	#name : 'PulsarTestRunResult',
	#superclass : 'Object',
	#instVars : [
		'passed',
		'failures',
		'errors',
		'skipped',
		'timestamp'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarTestRunResult class >> fromTestResult: aTestResult [
	"Create a PulsarTestRunResult from a SUnit TestResult."

	| result |
	result := self new.
	result timestamp: DateAndTime now.
	result passed: (aTestResult passed collect: [ :each |
				 PulsarTestResultItem new
					 testClassName: each class name;
					 testSelector: each selector;
					 status: #passed;
					 yourself ]).
	result failures: (aTestResult failures collect: [ :each |
				 PulsarTestResultItem new
					 testClassName: each class name;
					 testSelector: each selector;
					 status: #failure;
					 error: each;
					 yourself ]).
	result errors: (aTestResult errors collect: [ :each |
				 PulsarTestResultItem new
					 testClassName: each class name;
					 testSelector: each selector;
					 status: #error;
					 error: each;
					 yourself ]).
	result skipped: (aTestResult skipped collect: [ :each |
				 PulsarTestResultItem new
					 testClassName: each class name;
					 testSelector: each selector;
					 status: #skipped;
					 yourself ]).
	^ result
]

{ #category : 'accessing' }
PulsarTestRunResult >> errorCount [

	^ errors size
]

{ #category : 'accessing' }
PulsarTestRunResult >> failureCount [

	^ failures size
]

{ #category : 'testing' }
PulsarTestRunResult >> isEmpty [

	^ self totalCount = 0
]

{ #category : 'accessing' }
PulsarTestRunResult >> passedCount [

	^ passed size
]

{ #category : 'accessing' }
PulsarTestRunResult >> skippedCount [

	^ skipped size
]

{ #category : 'accessing' }
PulsarTestRunResult >> summaryString [

	^ '{1} passed, {2} failures, {3} errors, {4} skipped' format: {
			  self passedCount.
			  self failureCount.
			  self errorCount.
			  self skippedCount }
]

{ #category : 'accessing' }
PulsarTestRunResult >> totalCount [

	^ self passedCount + self failureCount + self errorCount + self skippedCount
]
