"
A single test case. Its entity is a TestCase instance (MyTest selector: #testFoo).

Slots: result (TestResult or nil after execution), isSelected (Boolean).
"
Class {
	#name : 'PulsarTestCase',
	#superclass : 'PvBaseModel',
	#instVars : [
		'result',
		'isSelected'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarTestCase >> children [

	^ #(  )
]

{ #category : 'accessing' }
PulsarTestCase >> description [

	^ self entity selector
]

{ #category : 'accessing' }
PulsarTestCase >> iconName [

	self flag: #TODO. "Use result status"
	^ #testNotRun
]

{ #category : 'accessing' }
PulsarTestCase >> isSelected [

	isSelected ifNil: [ isSelected := true ].
	^ isSelected
]

{ #category : 'accessing' }
PulsarTestCase >> isSelected: aBoolean [

	isSelected := aBoolean
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

{ #category : 'accessing' }
PulsarTestCase >> testClass [

	^ self parentModel entity
]

{ #category : 'accessing' }
PulsarTestCase >> testSelector [

	^ self entity selector
]

{ #category : 'selection' }
PulsarTestCase >> toggleSelection [

	self isSelected: self isSelected not
]
