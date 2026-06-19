Class {
	#name : 'PulsarUndeclaredMethodsVirtualProtocol',
	#superclass : 'PulsarVirtualProtocol',
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
PulsarUndeclaredMethodsVirtualProtocol >> methods [

	^ (self entity methods 
		select: [ :each | each usesUndeclareds ])
		sorted: #selector ascending
]

{ #category : 'accessing' }
PulsarUndeclaredMethodsVirtualProtocol >> name [

	^ 'Undeclared'
]

{ #category : 'accessing' }
PulsarUndeclaredMethodsVirtualProtocol >> order [

	^ 0
]

{ #category : 'testing' }
PulsarUndeclaredMethodsVirtualProtocol >> shouldBeDisplayed [

	^ self selectors isNotEmpty
]
