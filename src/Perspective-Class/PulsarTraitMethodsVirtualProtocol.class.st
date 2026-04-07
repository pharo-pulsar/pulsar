Class {
	#name : 'PulsarTraitMethodsVirtualProtocol',
	#superclass : 'PulsarVirtualProtocol',
	#instVars : [
		'trait'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarTraitMethodsVirtualProtocol class >> newEntity: aClass trait: aTrait [

	^ (self newEntity: aClass)
		trait: aTrait;
		yourself
]

{ #category : 'accessing' }
PulsarTraitMethodsVirtualProtocol >> cssStyle [

	^ 'trait'
]

{ #category : 'accessing' }
PulsarTraitMethodsVirtualProtocol >> iconName [

	^ 'trait'
]

{ #category : 'accessing' }
PulsarTraitMethodsVirtualProtocol >> name [

	^ self trait instanceSide name
]

{ #category : 'accessing' }
PulsarTraitMethodsVirtualProtocol >> order [

	^ 1000
]

{ #category : 'accessing' }
PulsarTraitMethodsVirtualProtocol >> selectors [

	^ self entity methods 
		select: [ :each | each origin = self trait ]
		thenCollect: [ :each | each selector ]
]

{ #category : 'accessing' }
PulsarTraitMethodsVirtualProtocol >> trait [

	^ trait
]

{ #category : 'accessing' }
PulsarTraitMethodsVirtualProtocol >> trait: aTrait [

	trait := aTrait
]
