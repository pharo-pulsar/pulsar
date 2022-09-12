Class {
	#name : #PvContainerPresenter,
	#superclass : #LnContainerPresenter,
	#instVars : [
		'name'
	],
	#category : #'Perspective-View-Container'
}

{ #category : #accessing }
PvContainerPresenter >> allViews [
	
	^ self allPresenters select: [ :each | each isView ]
]

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
PvContainerPresenter >> handleAnnouncement: anAnnouncement [ 

	anAnnouncement handleOn: self.
	self allViews do: [ :aPresenter | aPresenter announce: anAnnouncement ]
]

{ #category : #initialization }
PvContainerPresenter >> initialize [

	super initialize.
	self subscribeToAnnouncements
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
PvContainerPresenter >> spotterProcessorsFor: aSpotterStep context: context [
	
	"normal processing"
	super spotterProcessorsFor: aSpotterStep context: context.
	"traverse containers"
	self presenters do: [ :each | 
		each spotterProcessorsFor: aSpotterStep context: context ]
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
