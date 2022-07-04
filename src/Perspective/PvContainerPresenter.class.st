Class {
	#name : #PvContainerPresenter,
	#superclass : #LnContainerPresenter,
	#instVars : [
		'name'
	],
	#category : #'Perspective-View'
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

{ #category : #initialization }
PvContainerPresenter >> subscribeToAnnouncements [

	self announcer 
		when: PvAnnouncement 
		send: #handleAnnouncement: 
		to: self
]
