Class {
	#name : 'PvMethodOverridingDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodOverridingDecorator class >> appliesTo: aMethod [
	
	^ aMethod isOverriding and: [ aMethod isOverridden not ]
]

{ #category : 'accessing' }
PvMethodOverridingDecorator >> iconName [

	^ #arrowUp
]
