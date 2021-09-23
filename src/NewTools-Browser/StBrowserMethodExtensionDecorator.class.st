Class {
	#name : #StBrowserMethodExtensionDecorator,
	#superclass : #StBrowserMethodDecorator,
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #testing }
StBrowserMethodExtensionDecorator class >> appliesTo: aMethod [

	^ aMethod isExtension
]

{ #category : #accessing }
StBrowserMethodExtensionDecorator >> colorName [

	^ #gray
]
