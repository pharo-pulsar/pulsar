Class {
	#name : #PvPackagesListPresenter,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'packagesTreePresenter'
	],
	#category : #'Perspective-Package-View'
}

{ #category : #accessing }
PvPackagesListPresenter class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvPackagesListPresenter class >> defaultTitle [

	^ 'Packages'
]

{ #category : #initialization }
PvPackagesListPresenter >> connectPresenters [

	packagesTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	packagesTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ].
	
]

{ #category : #initialization }
PvPackagesListPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (packagesTreePresenter := self newEntityTree);
		yourself).
		
	packagesTreePresenter addStyle: 'stPackagesTree'
]

{ #category : #initialization }
PvPackagesListPresenter >> toolbarActions [
	| group |
	
	group := CmCommandGroup forSpec beRoot.
	group register: nil.
]

{ #category : #initialization }
PvPackagesListPresenter >> updatePresenter [

	packagesTreePresenter roots: self model flatPackages
]
