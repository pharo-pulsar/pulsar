"
A base for all perspective ""views"" (the components of a perspective).
Extensions to this class define diferent behaviors for perspectives.
"
Class {
	#name : #PvPerspectiveView,
	#superclass : #PvPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
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

{ #category : #'private - announcing' }
PvPerspectiveView >> announceActivated: aModel [

	aModel ifNil: [ ^ self ].
	perspective announce: aModel activatedAnnouncement
]

{ #category : #'private - announcing' }
PvPerspectiveView >> announceSelectionChanged: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective ifNil: [ ^ self ].
	perspective announce: aSelection selectedAnnouncement
]

{ #category : #accessing }
PvPerspectiveView >> containerName [

	^ containerName ifNil: [ self class defaultContainerName ]
]

{ #category : #accessing }
PvPerspectiveView >> containerName: aName [

	containerName := aName
]

{ #category : #'events - handling' }
PvPerspectiveView >> handleAnnouncement: ann [
	
	ann handleOn: self
]

{ #category : #initialization }
PvPerspectiveView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self title
]

{ #category : #accessing }
PvPerspectiveView >> perspective: aPerspective [
	
	perspective ifNotNil: [ 
		self unsubscribeFromAnnouncers  ].
	perspective := aPerspective.
	self subscribeToAnnouncements
]

{ #category : #initialization }
PvPerspectiveView >> subscribeToAnnouncements [

	perspective announcer 
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

{ #category : #initialization }
PvPerspectiveView >> unsubscribeFromAnnouncers [
	
	perspective announcer unsubscribe: self
]
