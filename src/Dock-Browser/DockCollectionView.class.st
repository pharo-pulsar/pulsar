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
		transmitDo: [ :anEntity | self entitySelected: anEntity ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self entityActivated: anEntity ]
]

{ #category : 'api - focus' }
DockCollectionView >> defaultKeyboardFocus [
	
	^ listPresenter
]

{ #category : 'layout' }
DockCollectionView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: listPresenter;
		yoursel
]

{ #category : 'private' }
DockCollectionView >> entityActivated: anEntity [ 

	self notifyActivateEntity: anEntity
]

{ #category : 'private' }
DockCollectionView >> entitySelected: anEntity [ 

	self notifySelectEntity: anEntity
]

{ #category : 'private - testing' }
DockCollectionView >> hasSelectedItem [

	^ self selectedItem isNotNil
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

{ #category : 'private - accessing' }
DockCollectionView >> selectedItem [

	^ listPresenter ifNotNil: #selectedItem
]
