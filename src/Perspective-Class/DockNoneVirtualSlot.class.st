Class {
	#name : 'DockNoneVirtualSlot',
	#superclass : 'Object',
	#instVars : [
		'entity'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
DockNoneVirtualSlot class >> newEntity: anObject [

	^ self new 
		entity: anObject;
		yourself
]

{ #category : 'accessing' }
DockNoneVirtualSlot >> entity [

	^ entity
]

{ #category : 'accessing' }
DockNoneVirtualSlot >> entity: aClass [

	entity := aClass
]

{ #category : 'testing' }
DockNoneVirtualSlot >> isIncludedIn: aMethodModel [

	^ true
]

{ #category : 'accessing' }
DockNoneVirtualSlot >> name [

	^ '(None)'
]

{ #category : 'accessing' }
DockNoneVirtualSlot >> slotName [
	
	^ ''
]
