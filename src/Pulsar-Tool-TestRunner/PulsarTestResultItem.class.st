"
A single test result item, wrapping a test outcome.

Holds the test class name, selector, execution status (passed/failure/error/skipped), optional error object, and duration.
"
Class {
	#name : 'PulsarTestResultItem',
	#superclass : 'Object',
	#instVars : [
		'testClassName',
		'testSelector',
		'status',
		'error',
		'duration'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarTestResultItem >> description [

	^ '{1} >> {2}' format: {
			  testClassName.
			  testSelector }
]

{ #category : 'testing' }
PulsarTestResultItem >> hasError [

	^ error isNotNil
]

{ #category : 'testing' }
PulsarTestResultItem >> isError [

	^ status = #error
]

{ #category : 'testing' }
PulsarTestResultItem >> isFailure [

	^ status = #failure
]

{ #category : 'testing' }
PulsarTestResultItem >> isPassed [

	^ status = #passed
]

{ #category : 'testing' }
PulsarTestResultItem >> isSkipped [

	^ status = #skipped
]

{ #category : 'accessing' }
PulsarTestResultItem >> statusIconName [

	self isPassed ifTrue: [ ^ #testPassed ].
	self isFailure ifTrue: [ ^ #testFailure ].
	self isError ifTrue: [ ^ #testError ].
	self isSkipped ifTrue: [ ^ #testNotRun ].
	^ #blank
]
