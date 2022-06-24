Class {
	#name : #PvPackagesListPresenter,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'packagesTreePresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #accessing }
PvPackagesListPresenter class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvPackagesListPresenter class >> defaultTitle [

	^ 'Packages'
]

{ #category : #'private - announcing' }
PvPackagesListPresenter >> announceActivated: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective announcer announce: (PvActivatedAnnouncement for: aSelection)
]

{ #category : #'private - announcing' }
PvPackagesListPresenter >> announceSelectionChanged: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective ifNil: [ ^ self ].
	perspective announcer announce: (PvSelectedAnnouncement for: aSelection)
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
PvPackagesListPresenter >> initializeToolbar: aToolbarPresenter [

	"aToolbarPresenter fillWith: self toolbarActions"
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
