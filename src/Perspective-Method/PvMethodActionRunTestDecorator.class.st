Class {
	#name : 'PvMethodActionRunTestDecorator',
	#superclass : 'PvMethodActionDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodActionRunTestDecorator class >> appliesTo: aMethod [

	^ aMethod isTestMethod
]

{ #category : 'accessing' }
PvMethodActionRunTestDecorator >> iconName [

	^ #play
]
