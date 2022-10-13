Class {
	#name : #PvMethodOverridenDecorator,
	#superclass : #PvMethodDecorator,
	#category : #'Perspective-Method-Model'
}

{ #category : #testing }
PvMethodOverridenDecorator class >> appliesTo: aMethod [
	
	^ aMethod isOverridden and: [ aMethod isOverriding not ]

]

{ #category : #accessing }
PvMethodOverridenDecorator >> iconName [

	^ #arrowDown
]
