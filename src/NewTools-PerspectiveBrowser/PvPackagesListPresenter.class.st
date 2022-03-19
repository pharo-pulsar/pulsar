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
	perspective announcer announce: (PvActivatedAnnouncement for: aSelection selectedItem)
]

{ #category : #'private - announcing' }
PvPackagesListPresenter >> announceSelectionChanged: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective ifNil: [ ^ self ].
	perspective announcer announce: (PvSelectedAnnouncement for: aSelection)
]

{ #category : #private }
PvPackagesListPresenter >> colorNamed: aString [

	self flag: #TODO. "Hardcoded. This has to be part of StPharoApplication"
	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
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
		add: (packagesTreePresenter := self newTree);
		yourself).
		
	packagesTreePresenter
		addStyle: 'stTree';
		addStyle: 'stPackagesList';
		display: [ :aPackageModel | aPackageModel name ];
		displayIcon: [ :aPackageModel | self iconNamed: aPackageModel iconName ];
		displayColor: [ :aPackageModel | self colorNamed: aPackageModel colorName ];
		children: [ :aPackageModel | aPackageModel children ]
]

{ #category : #initialization }
PvPackagesListPresenter >> initializeToolbar: aToolbarPresenter [

	"aToolbarPresenter fillWith: self toolbarActions"
]

{ #category : #initialization }
PvPackagesListPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self class defaultTitle
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
