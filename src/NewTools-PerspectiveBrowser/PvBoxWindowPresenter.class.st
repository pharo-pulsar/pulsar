Class {
	#name : #PvBoxWindowPresenter,
	#superclass : #LnBoxWindowPresenter,
	#category : #'NewTools-PerspectiveBrowser-View-Header'
}

{ #category : #private }
PvBoxWindowPresenter >> headerClass [

	^ LnBoxHeaderPresenter
	
]

{ #category : #'as yet unclassified' }
PvBoxWindowPresenter >> initializeToolbar: aToolbarPresenter [ 

	self presenter initializeToolbar: aToolbarPresenter
]
