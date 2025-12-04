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
		transmitDo: [ :anEntity | self notifySelectEntity: anEntity ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self notifyActivateEntity: anEntity ]
]

{ #category : 'private' }
DockCollectionView >> listPresenter [

	^ listPresenter
]

{ #category : 'private - announcing' }
DockCollectionView >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private - announcing' }
DockCollectionView >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newSelectionAnnouncement
]
