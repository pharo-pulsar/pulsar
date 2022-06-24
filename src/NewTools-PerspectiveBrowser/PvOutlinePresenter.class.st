Class {
	#name : #PvOutlinePresenter,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'classTreePresenter',
		'outlineTreePresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Outline'
}

{ #category : #accessing }
PvOutlinePresenter class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvOutlinePresenter class >> defaultTitle [

	^ 'Outline'
]

{ #category : #initialization }
PvOutlinePresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (outlineTreePresenter := self newEntityTree);
		yourself).
		
	outlineTreePresenter addStyle: 'stProjectTree'
]

{ #category : #'events - handling' }
PvOutlinePresenter >> itemWasActivated: ann [

	ann model accept: self
]

{ #category : #'events - handling' }
PvOutlinePresenter >> itemWasSelected: ann [

]

{ #category : #initialization }
PvOutlinePresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	outlineTreePresenter roots: self model children.
	self withTileWindowDo: [ :w | w title: self title ]
]

{ #category : #visiting }
PvOutlinePresenter >> visitClassModel: aModel [

	self model: (PvOutlineClassModel newEntity: aModel entity).
	self updatePresenter
]
