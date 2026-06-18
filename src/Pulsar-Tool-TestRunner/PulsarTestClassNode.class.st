"
A test tree node representing a test class.
"
Class {
	#name : 'PulsarTestClassNode',
	#superclass : 'PulsarTestNodeModel',
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarTestClassNode >> children [

	^ children ifNil: [ children := self collectChildren ].

]

{ #category : 'private' }
PulsarTestClassNode >> collectChildren [
	"Return method nodes for all test selectors in this class."

	^ self entity allTestMethods collect: [ :each | PulsarTestMethodNode newEntity: each parent: self model: self model ]
]

{ #category : 'activation' }
PulsarTestClassNode >> collectSelectedMethodsInto: aCollection [

	self children do: [ :each | each collectSelectedMethodsInto: aCollection ]
]

{ #category : 'accessing' }
PulsarTestClassNode >> description [

	^ self entity name
]

{ #category : 'accessing' }
PulsarTestClassNode >> iconName [

	^ self entity systemIconName
]

{ #category : 'accessing' }
PulsarTestClassNode >> testClass [

	^ self entity
]
