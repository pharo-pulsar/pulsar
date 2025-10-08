Class {
	#name : 'PvMethodOverridenDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodOverridenDecorator class >> appliesTo: aMethod [
	
	^ false "aMethod isOverridden and: [ aMethod isOverriding not ]"

]

{ #category : 'accessing' }
PvMethodOverridenDecorator >> iconName [

	^ #arrowDown
]
