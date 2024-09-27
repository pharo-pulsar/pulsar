Class {
	#name : 'PvEntityActivatedPort',
	#superclass : 'SpInputPort',
	#category : 'Perspective-View',
	#package : 'Perspective',
	#tag : 'View'
}

{ #category : 'handling transmission' }
PvEntityActivatedPort >> applyIncomingTransmission: anObject from: outPort to: aPresenter [
	"sets model to destination presenter"

	aPresenter entityActivated: anObject
]
