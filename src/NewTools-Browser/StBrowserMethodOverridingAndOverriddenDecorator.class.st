Class {
	#name : #StBrowserMethodOverridingAndOverriddenDecorator,
	#superclass : #StBrowserMethodDecorator,
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #testing }
StBrowserMethodOverridingAndOverriddenDecorator class >> appliesTo: aMethod [
	
	^ aMethod isOverriding and: [ aMethod isOverridden ]
]

{ #category : #accessing }
StBrowserMethodOverridingAndOverriddenDecorator >> iconName [

	^ 'arrow-small-up-down'
]
