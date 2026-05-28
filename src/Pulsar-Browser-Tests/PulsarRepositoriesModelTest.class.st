Class {
	#name : 'PulsarRepositoriesModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'tests - accessing' }
PulsarRepositoriesModelTest >> testName [
	| model |

	model := PulsarRepositoriesModel newEnvironment: self environmentModel.
	self assert: model name equals: 'Repositories'
]
