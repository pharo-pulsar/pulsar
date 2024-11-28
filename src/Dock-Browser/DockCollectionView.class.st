Class {
	#name : 'DockCollectionView',
	#superclass : 'DockBaseView',
	#instVars : [
		'listPresenter'
	],
	#classInstVars : [
		'aDockBrowser'
	],
	#category : 'Dock-Browser-Base',
	#package : 'Dock-Browser',
	#tag : 'Base'
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
