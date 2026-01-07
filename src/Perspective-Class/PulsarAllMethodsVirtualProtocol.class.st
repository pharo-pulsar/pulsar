Class {
	#name : 'PulsarAllMethodsVirtualProtocol',
	#superclass : 'Object',
	#instVars : [
		'entity'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarAllMethodsVirtualProtocol class >> newEntity: anObject [

	^ self new 
		entity: anObject;
		yourself
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> entity [

	^ entity
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> entity: aClass [

	entity := aClass
]

{ #category : 'accessing - ui' }
PulsarAllMethodsVirtualProtocol >> iconComposite [
	
	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> iconName [

	^ #protocolVirtual
]

{ #category : 'testing' }
PulsarAllMethodsVirtualProtocol >> isUnclassified [

	^ false
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> methodSelectors [

	^ self entity selectors
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> name [

	^ '(All)'
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> numberOfMethods [
	
	^ self selectors size
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> selectors [
	
	^ self entity selectors
]
