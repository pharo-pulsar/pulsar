Class {
	#name : 'PulsarMultiProjectModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'tests - creation' }
PulsarMultiProjectModelTest >> testInitializeCreatesEmptyProjectList [
	| model |

	model := PulsarMultiProjectModel newEnvironment: self environmentModel.
	self assert: model children equals: #(  )
]

{ #category : 'tests - accessing' }
PulsarMultiProjectModelTest >> testName [
	| model |

	model := PulsarMultiProjectModel newEnvironment: self environmentModel.
	self assert: model name equals: 'Projects'
]

{ #category : 'tests' }
PulsarMultiProjectModelTest >> testProjectNamed [
	"Test project lookup by name, accepting the BaselineOf prefix and ignoring case."

	| model |
	model := PulsarMultiProjectModel newEnvironment: self environmentModel.
	model addProject: BaselineOfPulsar.
	self assert: (model projectNamed: 'Pulsar') name equals: 'Pulsar'.
	self assert: (model projectNamed: 'BaselineOfPulsar') name equals: 'Pulsar'.
	self assert: (model projectNamed: 'baselineofpulsar') name equals: 'Pulsar'.
	self assert: (model projectNamed: 'pulsar') name equals: 'Pulsar'.
	self assert: (model projectNamed: 'Unknown') isNil
]
