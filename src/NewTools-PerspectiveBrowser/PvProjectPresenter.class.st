Class {
	#name : #PvProjectPresenter,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'projectTreePresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Project'
}

{ #category : #accessing }
PvProjectPresenter class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvProjectPresenter class >> defaultTitle [

	^ 'Project'
]

{ #category : #initialization }
PvProjectPresenter >> connectPresenters [

	projectTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	projectTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ]
]

{ #category : #initialization }
PvProjectPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (projectTreePresenter := self newEntityTree);
		yourself).
		
	projectTreePresenter addStyle: 'stProjectTree'
]

{ #category : #initialization }
PvProjectPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	projectTreePresenter roots: self model children.
	self withTileWindowDo: [ :window | window title: self title ]
]
