Class {
	#name : 'PulsarAllMethodsVirtualProtocol',
	#superclass : 'PulsarVirtualProtocol',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> name [

	^ '(All)'
]

{ #category : 'accessing' }
PulsarAllMethodsVirtualProtocol >> selectors [
	
	^ self entity selectors
]
