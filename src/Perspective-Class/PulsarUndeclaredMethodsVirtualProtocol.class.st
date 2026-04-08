Class {
	#name : 'PulsarUndeclaredMethodsVirtualProtocol',
	#superclass : 'PulsarVirtualProtocol',
	#instVars : [
		'selectors'
	],
	#category : 'Perspective-Class-Command',
	#package : 'Perspective-Class',
	#tag : 'Command'
}

{ #category : 'instance creation' }
PulsarUndeclaredMethodsVirtualProtocol class >> newEntity: aClass trait: aTrait [

	^ (self newEntity: aClass)
		trait: aTrait;
		yourself
]

{ #category : 'accessing' }
PulsarUndeclaredMethodsVirtualProtocol >> cssStyle [

	^ 'undeclared'
]

{ #category : 'accessing' }
PulsarUndeclaredMethodsVirtualProtocol >> iconName [

	^ nil
]

{ #category : 'accessing' }
PulsarUndeclaredMethodsVirtualProtocol >> name [

	^ 'Undeclared'
]

{ #category : 'accessing' }
PulsarUndeclaredMethodsVirtualProtocol >> order [

	^ 0
]

{ #category : 'accessing' }
PulsarUndeclaredMethodsVirtualProtocol >> selectors [

	^ selectors ifNil: [ 
		selectors := self entity methods 
			select: [ :each | each usesUndeclareds ]
			thenCollect: [ :each | each selector ] ]
]

{ #category : 'testing' }
PulsarUndeclaredMethodsVirtualProtocol >> shouldBeDisplayed [

	^ self selectors isNotEmpty
]
