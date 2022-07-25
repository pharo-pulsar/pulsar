Class {
	#name : #PvTabWindowPresenter,
	#superclass : #LnTabWindowPresenter,
	#category : #'Perspective-View-Window'
}

{ #category : #private }
PvTabWindowPresenter >> headerClass [

	^ PvTabHeaderPresenter
]

{ #category : #spotter }
PvTabWindowPresenter >> stSpotterProcessorsFor: aSpotterStep [
	
	self presenter stSpotterProcessorsFor: aSpotterStep
]

{ #category : #protocol }
PvTabWindowPresenter >> takeKeyboardFocus [

	self owner layout select: self.
	super takeKeyboardFocus

]
