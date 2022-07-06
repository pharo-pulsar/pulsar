Class {
	#name : #StBrowserMethodOverridenDecorator,
	#superclass : #StBrowserMethodDecorator,
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #testing }
StBrowserMethodOverridenDecorator class >> appliesTo: aMethod [
	
	^ aMethod isOverridden

]

{ #category : #accessing }
StBrowserMethodOverridenDecorator >> iconName [

	^ #arrowDown
]
