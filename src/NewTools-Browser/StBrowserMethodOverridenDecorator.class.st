Class {
	#name : #StBrowserMethodOverridenDecorator,
	#superclass : #StBrowserMethodDecorator,
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #testing }
StBrowserMethodOverridenDecorator class >> appliesTo: aMethod [
	
	^ aMethod isOverridden and: [ aMethod isOverriding not ]

]

{ #category : #accessing }
StBrowserMethodOverridenDecorator >> iconName [

	^ #arrowDown
]
