Class {
	#name : 'PulsarCollectionView',
	#superclass : 'PulsarBaseView',
	#instVars : [
		'listPresenter'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'initialization' }
PulsarCollectionView >> connectPresenters [

	listPresenter outputSelectionPort 
		transmitDo: [ :anEntity | self entitySelected: anEntity ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self entityActivated: anEntity ]
]

{ #category : 'api - focus' }
PulsarCollectionView >> defaultKeyboardFocus [
	
	^ listPresenter
]

{ #category : 'layout' }
PulsarCollectionView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: listPresenter;
		yourself
]

{ #category : 'private' }
PulsarCollectionView >> entityActivated: anEntity [ 

	self notifyActivateEntity: anEntity
]

{ #category : 'private' }
PulsarCollectionView >> entitySelected: anEntity [ 

	self notifySelectEntity: anEntity
]

{ #category : 'private - testing' }
PulsarCollectionView >> hasSelectedItem [

	^ self selectedItem isNotNil
]

{ #category : 'private' }
PulsarCollectionView >> listPresenter [

	^ listPresenter
]

{ #category : 'private - announcing' }
PulsarCollectionView >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private - announcing' }
PulsarCollectionView >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newSelectionAnnouncement
]

{ #category : 'private - accessing' }
PulsarCollectionView >> selectedItem [

	^ listPresenter ifNotNil: #selectedItem
]
