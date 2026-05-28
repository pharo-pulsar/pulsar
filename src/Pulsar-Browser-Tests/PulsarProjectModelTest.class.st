Class {
	#name : 'PulsarProjectModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
PulsarProjectModelTest >> pulsarProjectModel [

	^ PulsarProjectModel newEnvironment: self environmentModel entity: BaselineOfPulsar
]

{ #category : 'tests - ui' }
PulsarProjectModelTest >> testIconName [
	| model |

	model := self pulsarProjectModel.
	self assert: model iconName equals: 'project'
]

{ #category : 'tests - predicates' }
PulsarProjectModelTest >> testIsProject [
	| model |

	model := self pulsarProjectModel.
	self assert: model isProject
]

{ #category : 'tests - accessing' }
PulsarProjectModelTest >> testNameStripsBaselineOf [
	| model |

	model := self pulsarProjectModel.
	self assert: model name equals: 'Pulsar'
]
