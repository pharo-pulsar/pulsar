Class {
	#name : 'DockCollectionView',
	#superclass : 'DockBaseView',
	#instVars : [
		'listPresenter'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'initialization' }
DockCollectionView >> connectPresenters [

	listPresenter outputSelectionPort 
		transmitDo: [ :anEntity | self triggerSelectEntity: anEntity ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self triggerActivateEntity: anEntity ]
]

{ #category : 'private' }
DockCollectionView >> listPresenter [

	^ listPresenter
]
