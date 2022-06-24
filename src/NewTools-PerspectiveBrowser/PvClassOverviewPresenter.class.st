Class {
	#name : #PvClassOverviewPresenter,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'classTreePresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #accessing }
PvClassOverviewPresenter class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvClassOverviewPresenter class >> defaultTitle [

	^ 'Class'
]

{ #category : #'private - announcing' }
PvClassOverviewPresenter >> announceActivated: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective announcer announce: (PvActivatedAnnouncement for: aSelection selectedItem)
]

{ #category : #'private - announcing' }
PvClassOverviewPresenter >> announceSelectionChanged: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective ifNil: [ ^ self ].
	perspective announcer announce: (PvSelectedAnnouncement for: aSelection)
]

{ #category : #private }
PvClassOverviewPresenter >> colorNamed: aString [

	self flag: #TODO. "Hardcoded. This has to be part of StPharoApplication"
	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : #initialization }
PvClassOverviewPresenter >> connectPresenters [

	classTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	classTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ].
	
]

{ #category : #initialization }
PvClassOverviewPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (classTreePresenter := self newTree);
		yourself).
		
	classTreePresenter
		addStyle: 'stTree';
		addStyle: 'stClassOverview';
		display: [ :aClassModel | aClassModel name ];
		displayIcon: [ :aClassModel | self iconNamed: aClassModel iconName ];
		displayColor: [ :aPackageModel | self colorNamed: aPackageModel colorName ];
		children: [ :aPackageModel | aPackageModel children ]
]

{ #category : #initialization }
PvClassOverviewPresenter >> initializeToolbar: aToolbarPresenter [

	"aToolbarPresenter fillWith: self toolbarActions"
]

{ #category : #initialization }
PvClassOverviewPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self class defaultTitle
]

{ #category : #initialization }
PvClassOverviewPresenter >> toolbarActions [
	| group |
	
	group := CmCommandGroup forSpec beRoot.
	group register: nil.
]

{ #category : #initialization }
PvClassOverviewPresenter >> updatePresenter [

	classTreePresenter roots: self model flatPackages
]
