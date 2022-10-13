Class {
	#name : #StBrowserMethodOverridingDecorator,
	#superclass : #StBrowserMethodDecorator,
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #testing }
StBrowserMethodOverridingDecorator class >> appliesTo: aMethod [
	
	^ aMethod isOverriding and: [ aMethod isOverridden not ]
]

{ #category : #accessing }
StBrowserMethodOverridingDecorator >> iconName [

	^ #arrowUp
]
