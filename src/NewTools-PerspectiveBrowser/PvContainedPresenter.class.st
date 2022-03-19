Class {
	#name : #PvContainedPresenter,
	#superclass : #PvPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
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

{ #category : #accessing }
PvContainedPresenter >> containerName [

	^ containerName ifNil: [ self class defaultContainerName ]
]

{ #category : #accessing }
PvContainedPresenter >> containerName: aName [

	containerName := aName
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
	"override this to tell the perspective which announcements we want to listen."
]

{ #category : #initialization }
PvContainedPresenter >> unsubscribeFromAnnouncers [
	
	perspective announcer unsubscribe: self
]
