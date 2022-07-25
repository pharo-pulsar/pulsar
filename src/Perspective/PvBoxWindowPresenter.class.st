Class {
	#name : #PvBoxWindowPresenter,
	#superclass : #LnBoxWindowPresenter,
	#category : #'Perspective-View-Window'
}

{ #category : #private }
PvBoxWindowPresenter >> headerClass [

	^ PvBoxHeaderPresenter
	
]

{ #category : #spotter }
PvBoxWindowPresenter >> stSpotterProcessorsFor: aSpotterStep [
	
	self presenter stSpotterProcessorsFor: aSpotterStep
]
