Class {
	#name : 'DockNewSlotModel',
	#superclass : 'Object',
	#instVars : [
		'name',
		'slotType'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'defaults' }
DockNewSlotModel class >> defaultSlotType [

	^ InstanceVariableSlot
]

{ #category : 'accessing' }
DockNewSlotModel >> availableSlotTypes [

	^ Slot allSubclasses
]

{ #category : 'accessing' }
DockNewSlotModel >> name [

	^ name
]

{ #category : 'accessing' }
DockNewSlotModel >> name: aString [ 

	name := aString
]

{ #category : 'accessing' }
DockNewSlotModel >> slotType [

	^ slotType ifNil: [ slotType := self class defaultSlotType ]
]

{ #category : 'accessing' }
DockNewSlotModel >> slotType: aSlotClass [

	slotType := aSlotClass
]
