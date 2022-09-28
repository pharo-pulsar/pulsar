"
A base for all perspective ""views"" (the components of a perspective).
Extensions to this class define diferent behaviors for perspectives.
"
Class {
	#name : #PvPerspectiveView,
	#superclass : #PvPresenter,
	#traits : 'SpTModel + (SpTActivable - {#activate}) + (SpTSelectable - {#select}) + PvTActionHolder',
	#classTraits : 'SpTModel classTrait + SpTActivable classTrait + SpTSelectable classTrait + PvTActionHolder classTrait',
	#instVars : [
		'containerName',
		'perspective'
	],
	#category : #'Perspective-View'
}

{ #category : #accessing }
PvPerspectiveView class >> defaultContainerName [

	^ nil
]

{ #category : #accessing }
PvPerspectiveView class >> defaultTitle [

	^ 'Untitled'
]

{ #category : #'private - actions' }
PvPerspectiveView >> activateWith: anObject [

	anObject ifNil: [ ^ self ].
	self activationAction ifNil: [ ^ self ].
	self activationAction cull: (SpActivatedSelection newValue: anObject)
]

{ #category : #accessing }
PvPerspectiveView >> containerName [

	^ containerName ifNil: [ self class defaultContainerName ]
]

{ #category : #accessing }
PvPerspectiveView >> containerName: aName [

	containerName := aName
]

{ #category : #transmission }
PvPerspectiveView >> defaultOutputPort [

	^ self outputSelectionPort
]

{ #category : #'private - actions' }
PvPerspectiveView >> entityActivated: anEntity [
	"override this to add functionality to your activation input"
]

{ #category : #'private - actions' }
PvPerspectiveView >> entitySelected: anEntity [
	"override this to add functionality to your selection input"
]

{ #category : #'events - handling' }
PvPerspectiveView >> handleAnnouncement: ann [
	
	ann handleOn: self
]

{ #category : #initialization }
PvPerspectiveView >> initialize [

	super initialize.
	self subscribeToAnnouncements
]

{ #category : #initialization }
PvPerspectiveView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self title
]

{ #category : #transmission }
PvPerspectiveView >> inputActivatedPort [

	^ PvEntityActivatedPort newPresenter: self
]

{ #category : #transmission }
PvPerspectiveView >> inputSelectedPort [

	^ PvEntitySelectedPort newPresenter: self
]

{ #category : #testing }
PvPerspectiveView >> isCloseable [

	^ false
]

{ #category : #testing }
PvPerspectiveView >> isView [

	^ true
]

{ #category : #accessing }
PvPerspectiveView >> perspective: aPerspective [
	
	perspective := aPerspective
]

{ #category : #'private - actions' }
PvPerspectiveView >> selectWith: anObject [

	anObject ifNil: [ ^ self ].
	self selectionAction ifNil: [ ^ self ].
	self selectionAction cull: (SpActivatedSelection newValue: anObject)
]

{ #category : #accessing }
PvPerspectiveView >> spotterTitle [

	^ self title
]

{ #category : #initialization }
PvPerspectiveView >> subscribeToAnnouncements [

	self announcer 
		when: PvAnnouncement 
		send: #handleAnnouncement: 
		to: self
]

{ #category : #initialization }
PvPerspectiveView >> title [

	^ self model 
		ifNotNil: [ self titleWith: self model windowTitle ]
		ifNil: [ self class defaultTitle ]
]

{ #category : #private }
PvPerspectiveView >> titleWith: aString [

	^ String streamContents: [ :stream | 
		stream << self class defaultTitle << ': ' << aString ]
]
