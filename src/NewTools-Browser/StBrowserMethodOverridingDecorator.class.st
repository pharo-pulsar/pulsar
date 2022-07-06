Class {
	#name : #StBrowserMethodOverridingDecorator,
	#superclass : #StBrowserMethodDecorator,
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #testing }
StBrowserMethodOverridingDecorator class >> appliesTo: aMethod [
	
	^ aMethod isOverriding
]

{ #category : #accessing }
StBrowserMethodOverridingDecorator >> iconName [

	^ #arrowUp
]
