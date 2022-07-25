Class {
	#name : #PvContainerPresenter,
	#superclass : #LnContainerPresenter,
	#instVars : [
		'name'
	],
	#category : #'Perspective-View-Container'
}

{ #category : #converting }
PvContainerPresenter >> asEditorContainer [

	^ PvEditorContainerPresenter new 
		owner: self owner;
		name: self name;
		layout: self layout;
		yourself
]

{ #category : #initialization }
PvContainerPresenter >> defaultTileLayout [

	^ LnTileTabLayout uniqueInstance
]

{ #category : #'events - handling' }
PvContainerPresenter >> handleAnnouncement: ann [

	ann handleOn: self
]

{ #category : #initialization }
PvContainerPresenter >> initializePresenters [

	super initializePresenters.
	self addGlobalShortcutsTo: self
]

{ #category : #private }
PvContainerPresenter >> maybeRemoveContainer [

	self flag: #TODO. "Do not remove containers for the moment"
]

{ #category : #accessing }
PvContainerPresenter >> name [

	^ name
]

{ #category : #accessing }
PvContainerPresenter >> name: anObject [

	name := anObject
]

{ #category : #spotter }
PvContainerPresenter >> stSpotterProcessorsFor: aSpotterStep [
	
	"normal processing"
	super stSpotterProcessorsFor: aSpotterStep.
	"traverse containers"
	self presenters do: [ :each | 
		each stSpotterProcessorsFor: aSpotterStep ]
]

{ #category : #initialization }
PvContainerPresenter >> subscribeToAnnouncements [

	self announcer 
		when: PvAnnouncement 
		send: #handleAnnouncement: 
		to: self
]
