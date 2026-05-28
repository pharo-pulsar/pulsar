Class {
	#name : 'PulsarRepositoryModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
PulsarRepositoryModelTest >> pulsarRepoModel [
	| repo |

	repo := IceRepository registry detect: [ :r | r name = 'Pulsar' ].
	^ PulsarRepositoryModel newEnvironment: self environmentModel entity: repo
]

{ #category : 'tests - accessing' }
PulsarRepositoryModelTest >> testName [
	| model |

	model := self pulsarRepoModel.
	self assert: model name equals: 'Pulsar'
]

{ #category : 'tests - accessing' }
PulsarRepositoryModelTest >> testRepositoryLocation [
	| model |

	model := self pulsarRepoModel.
	self assert: model repositoryLocation isNotNil
]
