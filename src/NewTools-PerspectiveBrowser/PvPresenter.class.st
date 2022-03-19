Class {
	#name : #PvPresenter,
	#superclass : #SgaPresenter,
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #accessing }
PvPresenter >> boxWindowClass [

	^ PvBoxWindowPresenter
]

{ #category : #initialization }
PvPresenter >> initializeToolbar: aToolbarPresenter [ 

]

{ #category : #accessing }
PvPresenter >> tabWindowClass [

	^ PvTabWindowPresenter
]
