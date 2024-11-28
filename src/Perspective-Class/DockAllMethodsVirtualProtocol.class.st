Class {
	#name : 'DockAllMethodsVirtualProtocol',
	#superclass : 'Object',
	#instVars : [
		'entity'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
DockAllMethodsVirtualProtocol class >> newEntity: anObject [

	^ self new 
		entity: anObject;
		yourself
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> entity [

	^ entity
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> entity: aClass [

	entity := aClass
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> methodSelectors [

	^ self entity selectors
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> name [

	^ ''
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> selectors [
	
	^ self entity selectors
]
