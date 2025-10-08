Class {
	#name : 'PvMethodOverridingAndOverriddenDecorator',
	#superclass : 'PvMethodDecorator',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'testing' }
PvMethodOverridingAndOverriddenDecorator class >> appliesTo: aMethod [
	
	^ false "aMethod isOverriding and: [ aMethod isOverridden ]"
]

{ #category : 'accessing' }
PvMethodOverridingAndOverriddenDecorator >> iconName [

	^ 'arrow-small-up-down'
]
