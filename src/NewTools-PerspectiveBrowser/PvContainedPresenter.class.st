Class {
	#name : #PvContainedPresenter,
	#superclass : #PvPresenter,
	#traits : 'SpTModel + PvTModelVisitor',
	#classTraits : 'SpTModel classTrait + PvTModelVisitor classTrait',
	#instVars : [
		'containerName',
		'perspective'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
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
	perspective announcer announce: (PvActivatedAnnouncement for: aModel)
]

{ #category : #'private - announcing' }
PvContainedPresenter >> announceSelectionChanged: aSelection [

	aSelection ifNil: [ ^ self ].
	perspective ifNil: [ ^ self ].
	perspective announcer announce: (PvSelectedAnnouncement for: aSelection)
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
PvContainedPresenter >> entityActivated: ann [
	"Override if presenter will react to activation"
]

{ #category : #'events - handling' }
PvContainedPresenter >> entitySelected: ann [
	"Override if presenter will react to selection"
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
		when: PvSelectedAnnouncement send: #entitySelected: to: self;
		when: PvActivatedAnnouncement send: #entityActivated: to: self.
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
