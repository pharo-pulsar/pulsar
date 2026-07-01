"
A single test case. Its entity is a TestCase instance (MyTest selector: #testFoo).

Slots: result (TestResult or nil after execution), isSelected (Boolean).
"
Class {
	#name : 'PulsarTestCase',
	#superclass : 'PulsarBaseTestModel',
	#instVars : [
		'result',
		'duration'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'converting' }
PulsarTestCase >> asEntityModel [

	^ PvMethodModel 
		newEnvironment: self environmentModel
		entity: self entity class >> self entity selector
]

{ #category : 'accessing' }
PulsarTestCase >> children [

	^ #(  )
]

{ #category : 'accessing' }
PulsarTestCase >> description [

	^ self entity selector
]

{ #category : 'accessing' }
PulsarTestCase >> duration [

	^ duration
]

{ #category : 'accessing' }
PulsarTestCase >> duration: anInteger [

	duration := anInteger
]

{ #category : 'accessing' }
PulsarTestCase >> fullDescription [

	^ '{1} · {2}' format: {
			  self testClass name.
			  self entity selector }
]

{ #category : 'accessing' }
PulsarTestCase >> name [

	^ self entity selector
]

{ #category : 'accessing' }
PulsarTestCase >> result [

	^ result
]

{ #category : 'accessing' }
PulsarTestCase >> result: anObject [

	result := anObject
]

{ #category : 'running' }
PulsarTestCase >> runOn: anActionContext [
	
	^ anActionContext doRunCase: self
]

{ #category : 'accessing' }
PulsarTestCase >> statusDescription [
	
	^ super statusDescription ifNil: [ 'Test not ran' ]
]

{ #category : 'accessing' }
PulsarTestCase >> statusLabel [

	result ifNil: [ ^ 'Passed' ].
	result == #failure ifTrue: [ ^ 'Failed' ].
	result == #error ifTrue: [ ^ 'Error' ].
	^ 'Unknown'
]

{ #category : 'accessing' }
PulsarTestCase >> testClass [

	^ self parentModel entity
]

{ #category : 'accessing' }
PulsarTestCase >> testSelector [

	^ self entity selector
]
