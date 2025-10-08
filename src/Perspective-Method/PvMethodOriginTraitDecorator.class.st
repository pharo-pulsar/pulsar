Class {
	#name : 'PvMethodOriginTraitDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodOriginTraitDecorator class >> appliesTo: aMethod [

	^ aMethod isFromTrait
]

{ #category : 'accessing' }
PvMethodOriginTraitDecorator >> style [

	^ 'trait'
]
