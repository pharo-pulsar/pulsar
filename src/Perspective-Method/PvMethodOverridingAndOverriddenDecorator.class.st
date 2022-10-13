Class {
	#name : #PvMethodOverridingAndOverriddenDecorator,
	#superclass : #PvMethodDecorator,
	#category : #'Perspective-Method-Model'
}

{ #category : #testing }
PvMethodOverridingAndOverriddenDecorator class >> appliesTo: aMethod [
	
	^ aMethod isOverriding and: [ aMethod isOverridden ]
]

{ #category : #accessing }
PvMethodOverridingAndOverriddenDecorator >> iconName [

	^ 'arrow-small-up-down'
]
