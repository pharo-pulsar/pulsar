"
A test tree node representing a single test method.
"
Class {
	#name : 'PulsarTestMethodNode',
	#superclass : 'PulsarTestNodeModel',
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarTestMethodNode >> children [

	^ #(  )
]

{ #category : 'activation' }
PulsarTestMethodNode >> collectSelectedMethodsInto: aCollection [

	self isActive ifTrue: [ aCollection add: self ]
]

{ #category : 'accessing' }
PulsarTestMethodNode >> description [

	^ self entity selector
]

{ #category : 'accessing' }
PulsarTestMethodNode >> iconName [

	self flag: #TODO. "Use result status"
	^ #testNotRun
]

{ #category : 'accessing' }
PulsarTestMethodNode >> testClass [

	^ self entity methodClass instanceSide
]

{ #category : 'accessing' }
PulsarTestMethodNode >> testSelector [

	^ self entity selector
]
