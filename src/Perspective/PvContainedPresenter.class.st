Class {
	#name : #PvContainedPresenter,
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
PvContainedPresenter class >> defaultContainerName [

	^ nil
]

{ #category : #accessing }
PvContainedPresenter class >> defaultTitle [

	^ 'Untitled'
]

{ #category : #'private - announcing' }
PvContainedPresenter >> announceActivated: aModel [

	aModel ifNil: [ ^ self ].
	perspective announce: aModel activatedAnnouncement
]

{ #category : #'private - announcing' }
PvContainedPresenter >> announceSelectionChanged: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective ifNil: [ ^ self ].
	perspective announce: aSelection selectedAnnouncement
]

{ #category : #accessing }
PvContainedPresenter >> containerName [

	^ containerName ifNil: [ self class defaultContainerName ]
]

{ #category : #accessing }
PvContainedPresenter >> containerName: aName [

	containerName := aName
]

{ #category : #'events - handling' }
PvContainedPresenter >> handleAnnouncement: ann [
	
	ann handleOn: self
]

{ #category : #initialization }
PvContainedPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self title
]

{ #category : #accessing }
PvContainedPresenter >> perspective: aPerspective [
	
	perspective ifNotNil: [ 
		self unsubscribeFromAnnouncers  ].
	perspective := aPerspective.
	self subscribeToAnnouncements
]

{ #category : #initialization }
PvContainedPresenter >> subscribeToAnnouncements [

	perspective announcer 
		when: PvAnnouncement 
		send: #handleAnnouncement: 
		to: self
]

{ #category : #initialization }
PvContainedPresenter >> title [

	^ self model 
		ifNotNil: [ self titleWith: self model windowTitle ]
		ifNil: [ self class defaultTitle ]
]

{ #category : #private }
PvContainedPresenter >> titleWith: aString [

	^ String streamContents: [ :stream | 
		stream << self class defaultTitle << ': ' << aString ]
]

{ #category : #initialization }
PvContainedPresenter >> unsubscribeFromAnnouncers [
	
	perspective announcer unsubscribe: self
]
