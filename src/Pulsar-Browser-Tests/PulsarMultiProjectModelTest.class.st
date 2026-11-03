Class {
	#name : 'PulsarMultiProjectModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'tests' }
PulsarMultiProjectModelTest >> testInitializeCreatesEmptyProjectList [

	| model |
	model := PulsarMultiProjectModel
		newWithoutVolatileProjectsEnvironment: self environmentModel.
	self assert: model children equals: #()
]

{ #category : 'tests' }
PulsarMultiProjectModelTest >> testName [

	| model |
	model := PulsarMultiProjectModel
		newWithoutVolatileProjectsEnvironment: self environmentModel.
	self assert: model name equals: 'Projects'
]

{ #category : 'tests' }
PulsarMultiProjectModelTest >> testProjectNamed [

	"Test project lookup by name, accepting the BaselineOf prefix and ignoring case."
	| model baseline name |
	model := PulsarMultiProjectModel
		newWithoutVolatileProjectsEnvironment: self environmentModel.
	baseline := self baselineFixture.
	name := baseline name allButFirst: 10.
	model addProject: baseline.
	self assert: (model projectNamed: name) name equals: name.
	self assert: (model projectNamed: baseline name) name equals: name.
	self assert: (model projectNamed: baseline name asLowercase) name equals: name.
	self assert: (model projectNamed: name asLowercase) name equals: name.
	self assert: (model projectNamed: 'Unknown') isNil
]
