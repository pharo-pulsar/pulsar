Class {
	#name : #PvProjectView,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'projectTreePresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Project'
}

{ #category : #accessing }
PvProjectView class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvProjectView class >> defaultTitle [

	^ 'Project'
]

{ #category : #initialization }
PvProjectView >> connectPresenters [

	projectTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	projectTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ]
]

{ #category : #initialization }
PvProjectView >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (projectTreePresenter := self newEntityTree);
		yourself).
		
	projectTreePresenter addStyle: 'stProjectTree'
]

{ #category : #initialization }
PvProjectView >> updatePresenter [

	self model ifNil: [ ^ self ].
	projectTreePresenter roots: self model children.
	self withTileWindowDo: [ :w | 
		w windowIcon: (self iconNamed: self model windowIconName).
		w title: self title ]
]
