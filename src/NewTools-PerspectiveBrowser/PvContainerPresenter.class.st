Class {
	#name : #PvContainerPresenter,
	#superclass : #LnContainerPresenter,
	#instVars : [
		'name'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
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
PvContainerPresenter >> entityActivated: ann [
]

{ #category : #'events - handling' }
PvContainerPresenter >> entitySelected: ann [
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
		when: PvSelectedAnnouncement send: #entitySelected: to: self;
		when: PvActivatedAnnouncement send: #entityActivated: to: self
]
