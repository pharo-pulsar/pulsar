Class {
	#name : 'PulsarNoneVirtualSlot',
	#superclass : 'Object',
	#instVars : [
		'entity'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarNoneVirtualSlot class >> newEntity: anObject [

	^ self new 
		entity: anObject;
		yourself
]

{ #category : 'accessing - actions' }
PulsarNoneVirtualSlot >> actionsWithContextOn: aContextPresenter [

	^ SpActionGroup new
]

{ #category : 'accessing' }
PulsarNoneVirtualSlot >> entity [

	^ entity
]

{ #category : 'accessing' }
PulsarNoneVirtualSlot >> entity: aClass [

	entity := aClass
]

{ #category : 'testing' }
PulsarNoneVirtualSlot >> isFromTrait [

	^ false
]

{ #category : 'testing' }
PulsarNoneVirtualSlot >> isIncludedIn: aMethodModel [

	^ true
]

{ #category : 'accessing' }
PulsarNoneVirtualSlot >> name [

	^ '(None)'
]

{ #category : 'accessing' }
PulsarNoneVirtualSlot >> slotName [
	
	^ ''
]
