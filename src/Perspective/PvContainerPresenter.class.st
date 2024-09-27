Class {
	#name : 'PvContainerPresenter',
	#superclass : 'LnContainerPresenter',
	#traits : 'PvTActionHolder',
	#classTraits : 'PvTActionHolder classTrait',
	#instVars : [
		'name'
	],
	#category : 'Perspective-View-Container',
	#package : 'Perspective',
	#tag : 'View-Container'
}

{ #category : 'accessing' }
PvContainerPresenter class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #container with: {
			KeyboardKey up 		mod3 shift  -> PvFocusUpAction new.
			KeyboardKey down 	mod3 shift  -> PvFocusDownAction new.
			KeyboardKey left 	mod3 shift  -> PvFocusLeftAction new.
			KeyboardKey right 	mod3 shift  -> PvFocusRightAction new.
		}
]

{ #category : 'accessing' }
PvContainerPresenter >> allViews [
	
	^ self allPresenters select: [ :each | each isView ]
]

{ #category : 'converting' }
PvContainerPresenter >> asEditorContainer [

	^ PvEditorContainerPresenter new 
		owner: self owner;
		name: self name;
		layout: self layout;
		yourself
]

{ #category : 'initialization' }
PvContainerPresenter >> defaultTileLayout [

	^ LnTileTabLayout uniqueInstance
]

{ #category : 'private settings' }
PvContainerPresenter >> globalActions [

	^ self actions
]

{ #category : 'events - handling' }
PvContainerPresenter >> handleAnnouncement: anAnnouncement [ 

	anAnnouncement handleOn: self.
	self allViews do: [ :aPresenter | aPresenter announce: anAnnouncement ]
]

{ #category : 'initialization' }
PvContainerPresenter >> initialize [

	super initialize.
	self subscribeToAnnouncements
]

{ #category : 'initialization' }
PvContainerPresenter >> initializePresenters [

	super initializePresenters.
	self addStyle: 'pvContainer'.
	self addGlobalActionsTo: self
]

{ #category : 'private' }
PvContainerPresenter >> maybeRemoveContainer [

	self flag: #TODO. "Do not remove containers for the moment"
]

{ #category : 'accessing' }
PvContainerPresenter >> name [

	^ name
]

{ #category : 'accessing' }
PvContainerPresenter >> name: anObject [

	name := anObject
]

{ #category : 'spotter' }
PvContainerPresenter >> spotterProcessorsFor: aSpotterStep context: context [
	
	"normal processing"
	super spotterProcessorsFor: aSpotterStep context: context.
	"traverse containers"
	self presenters do: [ :each | 
		each spotterProcessorsFor: aSpotterStep context: context ]
]

{ #category : 'spotter' }
PvContainerPresenter >> stSpotterProcessorsFor: aSpotterStep [
	
	"normal processing"
	super stSpotterProcessorsFor: aSpotterStep.
	"traverse containers"
	self presenters do: [ :each | 
		each stSpotterProcessorsFor: aSpotterStep ]
]

{ #category : 'initialization' }
PvContainerPresenter >> subscribeToAnnouncements [

	self announcer 
		when: PvAnnouncement 
		send: #handleAnnouncement: 
		to: self
]
