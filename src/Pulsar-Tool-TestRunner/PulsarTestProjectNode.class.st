"
A test tree node representing a package containing test classes.
"
Class {
	#name : 'PulsarTestProjectNode',
	#superclass : 'PulsarTestNodeModel',
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarTestProjectNode >> children [

	^ children ifNil: [ children := self collectChildren ]
]

{ #category : 'private' }
PulsarTestProjectNode >> collectChildren [
	"Return package children that contain test classes."

	^ Array streamContents: [ :stream |
			  self entity children select: #isPackage thenDo: [ :each |
					  | packageNode |
					  packageNode := PulsarTestPackageNode newEntity: each parent: self model: self model.
					  packageNode children ifNotEmpty: [ stream nextPut: packageNode ] ] ]
]

{ #category : 'activation' }
PulsarTestProjectNode >> collectSelectedMethodsInto: aCollection [

	self children do: [ :each | each collectSelectedMethodsInto: aCollection ]
]

{ #category : 'accessing' }
PulsarTestProjectNode >> description [

	^ self entity name
]

{ #category : 'accessing' }
PulsarTestProjectNode >> iconName [

	^ self entity iconName
]
