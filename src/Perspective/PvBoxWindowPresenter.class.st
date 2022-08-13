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
PvBoxWindowPresenter >> spotterProcessorsFor: aSpotterStep context: context [
	
	self presenter 
		spotterProcessorsFor: aSpotterStep 
		context: context
]

{ #category : #spotter }
PvBoxWindowPresenter >> stSpotterProcessorsFor: aSpotterStep [
	
	self presenter stSpotterProcessorsFor: aSpotterStep
]
