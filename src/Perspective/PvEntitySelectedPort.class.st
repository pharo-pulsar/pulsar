Class {
	#name : 'PvEntitySelectedPort',
	#superclass : 'SpInputPort',
	#category : 'Perspective-View',
	#package : 'Perspective',
	#tag : 'View'
}

{ #category : 'handling transmission' }
PvEntitySelectedPort >> applyIncomingTransmission: anObject from: outPort to: aPresenter [
	"sets model to destination presenter"

	aPresenter entitySelected: anObject
]
