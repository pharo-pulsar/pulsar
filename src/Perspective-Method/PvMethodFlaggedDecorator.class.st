Class {
	#name : 'PvMethodFlaggedDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodFlaggedDecorator class >> appliesTo: aMethod [

	^ aMethod hasFlag
]

{ #category : 'accessing' }
PvMethodFlaggedDecorator >> iconName [

	^ #flagIcon
]
