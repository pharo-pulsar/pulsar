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
