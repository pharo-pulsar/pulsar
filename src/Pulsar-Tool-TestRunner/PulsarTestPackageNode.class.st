"
A test tree node representing a package containing test classes.
"
Class {
	#name : 'PulsarTestPackageNode',
	#superclass : 'PulsarTestNodeModel',
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarTestPackageNode >> children [

	^ children ifNil: [ children := self collectChildren ]
]

{ #category : 'private' }
PulsarTestPackageNode >> collectChildren [
	"Return non-abstract TestCase subclasses defined in this package as class nodes."

	^ Array streamContents: [ :stream |
			  self entity classes do: [ :eachClassModel |
					  (eachClassModel isTestCase and: [ eachClassModel isAbstract not ]) ifTrue: [
						  stream nextPut: (PulsarTestClassNode newEntity: eachClassModel parent: self model: self model) ] ] ]
]

{ #category : 'activation' }
PulsarTestPackageNode >> collectSelectedMethodsInto: aCollection [

	self children do: [ :each | each collectSelectedMethodsInto: aCollection ]
]

{ #category : 'accessing' }
PulsarTestPackageNode >> description [

	^ self entity name
]

{ #category : 'accessing' }
PulsarTestPackageNode >> iconName [

	^ self entity iconName
]
