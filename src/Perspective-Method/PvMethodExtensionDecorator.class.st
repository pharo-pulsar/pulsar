Class {
	#name : 'PvMethodExtensionDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodExtensionDecorator class >> appliesTo: aMethod [

	^ aMethod isExtension
]

{ #category : 'accessing' }
PvMethodExtensionDecorator >> colorName [

	^ #gray
]
