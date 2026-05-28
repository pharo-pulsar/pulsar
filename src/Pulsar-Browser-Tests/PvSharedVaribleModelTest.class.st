Class {
	#name : 'PvSharedVaribleModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'tests - ui' }
PvSharedVaribleModelTest >> testIconNameDefaultsToNil [
	| model |

	model := PvSharedVaribleModel newEnvironment: self environmentModel.
	self assert: model iconName isNil
]

{ #category : 'tests - accessing' }
PvSharedVaribleModelTest >> testNameAccessors [
	| model |

	model := PvSharedVaribleModel newEnvironment: self environmentModel.
	model name: 'MyVar'.
	self assert: model name equals: 'MyVar'
]
