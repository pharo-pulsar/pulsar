Class {
	#name : 'PulsarNewSlotModel',
	#superclass : 'Object',
	#instVars : [
		'name',
		'slotType'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'defaults' }
PulsarNewSlotModel class >> defaultSlotType [

	^ InstanceVariableSlot
]

{ #category : 'accessing' }
PulsarNewSlotModel >> availableSlotTypes [

	^ Slot allSubclasses
]

{ #category : 'accessing' }
PulsarNewSlotModel >> name [

	^ name
]

{ #category : 'accessing' }
PulsarNewSlotModel >> name: aString [ 

	name := aString
]

{ #category : 'accessing' }
PulsarNewSlotModel >> slotType [

	^ slotType ifNil: [ slotType := self class defaultSlotType ]
]

{ #category : 'accessing' }
PulsarNewSlotModel >> slotType: aSlotClass [

	slotType := aSlotClass
]
