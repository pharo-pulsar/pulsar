Class {
	#name : 'PulsarAllMethodsVirtualProtocol',
	#superclass : 'PulsarVirtualProtocol',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> methods [

	^ (self entity methods 
		reject: [ :each | each origin = TraitedClass ])
		sorted: #selector ascending
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> name [

	^ '(All)'
]
