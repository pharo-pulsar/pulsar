Class {
	#name : #PvTabWindowPresenter,
	#superclass : #LnTabWindowPresenter,
	#category : #'NewTools-PerspectiveBrowser-View-Header'
}

{ #category : #private }
PvTabWindowPresenter >> headerClass [

	^ PvTabHeaderPresenter
]

{ #category : #initialization }
PvTabWindowPresenter >> initializeToolbar: aToolbarPresenter [ 

	self presenter initializeToolbar: aToolbarPresenter
]
