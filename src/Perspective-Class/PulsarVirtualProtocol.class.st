Class {
	#name : 'PulsarVirtualProtocol',
	#superclass : 'Object',
	#instVars : [
		'entity'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarVirtualProtocol class >> newEntity: anObject [

	^ self new 
		entity: anObject;
		yourself
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> cssStyle [

	^ nil
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> entity [

	^ entity
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> entity: aClass [

	entity := aClass
]

{ #category : 'accessing - ui' }
PulsarVirtualProtocol >> iconComposite [
	
	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> iconName [

	^ #protocolVirtual
]

{ #category : 'testing' }
PulsarVirtualProtocol >> isExtension [
	
	^ true
]

{ #category : 'testing' }
PulsarVirtualProtocol >> isPrivate [
	
	^ false
]

{ #category : 'testing' }
PulsarVirtualProtocol >> isUnclassified [

	^ false
]

{ #category : 'testing' }
PulsarVirtualProtocol >> isVirtual [
	
	^ true
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> methodSelectors [

	^ self selectors
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> name [

	self subclassResponsibility
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> numberOfMethods [
	
	^ self selectors size
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> order [

	^ 0
]

{ #category : 'accessing' }
PulsarVirtualProtocol >> selectors [

	^ self subclassResponsibility
]
