Class {
	#name : 'PvMethodExtensionDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodExtensionDecorator class >> appliesTo: aMethod [

	^ aMethod isExtension or: [ aMethod protocol isExtensionProtocol ]
]

{ #category : 'accessing' }
PvMethodExtensionDecorator >> colorName [

	^ #gray
]

{ #category : 'accessing' }
PvMethodExtensionDecorator >> style [

	^ 'extension'
]
