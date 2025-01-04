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

{ #category : 'accessing - ui' }
DockAllMethodsVirtualProtocol >> iconComposite [
	
	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> iconName [

	^ #protocolVirtual
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> methodSelectors [

	^ self entity selectors
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> name [

	^ '(All)'
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> numberOfMethods [
	
	^ self selectors size
]

{ #category : 'accessing' }
DockAllMethodsVirtualProtocol >> selectors [
	
	^ self entity selectors
]
