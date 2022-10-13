Class {
	#name : #PvMethodExtensionDecorator,
	#superclass : #PvMethodDecorator,
	#category : #'Perspective-Method-Model'
}

{ #category : #testing }
PvMethodExtensionDecorator class >> appliesTo: aMethod [

	^ aMethod isExtension
]

{ #category : #accessing }
PvMethodExtensionDecorator >> colorName [

	^ #gray
]
