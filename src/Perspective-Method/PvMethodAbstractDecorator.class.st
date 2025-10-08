Class {
	#name : 'PvMethodAbstractDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodAbstractDecorator class >> appliesTo: aMethod [

	^ aMethod isAbstract
]

{ #category : 'accessing' }
PvMethodAbstractDecorator >> style [

	^ 'abstract'
]
