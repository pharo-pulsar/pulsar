Class {
	#name : #PvMethodFlaggedDecorator,
	#superclass : #PvMethodDecorator,
	#category : #'Perspective-Method-Model'
}

{ #category : #testing }
PvMethodFlaggedDecorator class >> appliesTo: aMethod [

	^ aMethod sendsAnySelectorOf: #(flag:)
]

{ #category : #accessing }
PvMethodFlaggedDecorator >> iconName [

	^ #flagIcon
]
