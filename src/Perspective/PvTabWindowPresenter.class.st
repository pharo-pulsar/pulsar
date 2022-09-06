Class {
	#name : #PvTabWindowPresenter,
	#superclass : #LnTabWindowPresenter,
	#category : #'Perspective-View-Window'
}

{ #category : #'opening-closing' }
PvTabWindowPresenter >> close [

	self delete
]

{ #category : #private }
PvTabWindowPresenter >> headerClass [

	^ PvTabHeaderPresenter
]

{ #category : #testing }
PvTabWindowPresenter >> isCloseable [
	
	^ presenter isCloseable
]

{ #category : #spotter }
PvTabWindowPresenter >> spotterProcessorsFor: aSpotterStep context: context [
	
	self presenter 
		spotterProcessorsFor: aSpotterStep 
		context: context
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
