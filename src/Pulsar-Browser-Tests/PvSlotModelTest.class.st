Class {
	#name : 'PvSlotModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
PvSlotModelTest >> slotModel [
	| slot |

	slot := Object class allSlots first.
	^ PvSlotModel newEnvironment: self environmentModel entity: slot
]

{ #category : 'tests - ui' }
PvSlotModelTest >> testIconName [
	| model |

	model := self slotModel.
	self assert: model iconName equals: 'variable'
]

{ #category : 'tests - accessing' }
PvSlotModelTest >> testName [
	| model |

	model := self slotModel.
	self assert: model name isNotNil
]
