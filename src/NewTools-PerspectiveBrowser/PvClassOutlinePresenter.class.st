Class {
	#name : #PvClassOutlinePresenter,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'classTreePresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #accessing }
PvClassOutlinePresenter class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvClassOutlinePresenter class >> defaultTitle [

	^ 'Class'
]

{ #category : #'private - announcing' }
PvClassOutlinePresenter >> announceActivated: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective announcer announce: (PvActivatedAnnouncement for: aSelection selectedItem)
]

{ #category : #'private - announcing' }
PvClassOutlinePresenter >> announceSelectionChanged: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective ifNil: [ ^ self ].
	perspective announcer announce: (PvSelectedAnnouncement for: aSelection)
]

{ #category : #private }
PvClassOutlinePresenter >> colorNamed: aString [

	self flag: #TODO. "Hardcoded. This has to be part of StPharoApplication"
	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : #initialization }
PvClassOutlinePresenter >> connectPresenters [

	classTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	classTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ].
	
]

{ #category : #initialization }
PvClassOutlinePresenter >> initializePresenters [

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
PvClassOutlinePresenter >> initializeToolbar: aToolbarPresenter [

	"aToolbarPresenter fillWith: self toolbarActions"
]

{ #category : #initialization }
PvClassOutlinePresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self class defaultTitle
]

{ #category : #initialization }
PvClassOutlinePresenter >> toolbarActions [
	| group |
	
	group := CmCommandGroup forSpec beRoot.
	group register: nil.
]

{ #category : #initialization }
PvClassOutlinePresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	classTreePresenter roots: self model entities
]
