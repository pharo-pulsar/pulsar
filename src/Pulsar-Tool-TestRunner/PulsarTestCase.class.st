"
A single test case. Its entity is a TestCase instance (MyTest selector: #testFoo).

Slots: result (TestResult or nil after execution), isSelected (Boolean).
"
Class {
	#name : 'PulsarTestCase',
	#superclass : 'PulsarBaseTestModel',
	#instVars : [
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

{ #category : 'running' }
PulsarTestCase >> debugOn: anActionContext [
	
	^ anActionContext doDebugCase: self
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

	^ '{1} {2} {3}' format: {
			  self testClass name.
			  (Character value: 16r232A) asString.
			  self entity selector }
]

{ #category : 'accessing' }
PulsarTestCase >> name [

	^ self entity selector
]

{ #category : 'running' }
PulsarTestCase >> runOn: anActionContext [
	
	^ anActionContext doRunCase: self
]

{ #category : 'accessing' }
PulsarTestCase >> status [
	| history |

	history := self testClass history.
	
	((history at: #errors ifAbsent: [ #() ]) includes: self testSelector) ifTrue: [ ^ #error ].
	((history at: #failures ifAbsent: [ #() ]) includes: self testSelector) ifTrue: [ ^ #failure ].
	((history at: #passed ifAbsent: [ #() ]) includes: self testSelector) ifTrue: [ ^ #passed ].
	
	^ #passed
]

{ #category : 'accessing' }
PulsarTestCase >> statusDescription [
	
	^ super statusDescription ifNil: [ 'Test not ran' ]
]

{ #category : 'accessing' }
PulsarTestCase >> statusLabel [
	| status |

	status := self status.
	status == #passed ifTrue: [ ^ 'Passed' ].
	status == #failure ifTrue: [ ^ 'Failed' ].
	status == #error ifTrue: [ ^ 'Error' ].
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
