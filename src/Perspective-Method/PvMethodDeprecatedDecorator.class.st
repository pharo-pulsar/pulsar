Class {
	#name : 'PvMethodDeprecatedDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodDeprecatedDecorator class >> appliesTo: aMethod [

	^ aMethod isDeprecated
]

{ #category : 'accessing' }
PvMethodDeprecatedDecorator >> colorName [

	^ #gray
]

{ #category : 'accessing' }
PvMethodDeprecatedDecorator >> style [

	^ 'deprecated'
]
