Class {
	#name : #StBrowserMethodFlaggedDecorator,
	#superclass : #StBrowserMethodDecorator,
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #testing }
StBrowserMethodFlaggedDecorator class >> appliesTo: aMethod [

	^ aMethod sendsAnySelectorOf: #(flag:)
]

{ #category : #accessing }
StBrowserMethodFlaggedDecorator >> iconName [

	^ #flagIcon
]
