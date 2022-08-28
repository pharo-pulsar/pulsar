Class {
	#name : #PvSystemNavigation,
	#superclass : #SystemNavigation,
	#instVars : [
		'perspective'
	],
	#category : #'Perspective-View-Perspective'
}

{ #category : #'instance creation' }
PvSystemNavigation class >> newPerspective: aPerspective [

	^ self new 
		perspective: aPerspective;
		yourself
]

{ #category : #accessing }
PvSystemNavigation >> application [

	^ self perspective application
]

{ #category : #opening }
PvSystemNavigation >> browse: anObject [

	self perspective activateClass: anObject class instanceSide	
]

{ #category : #enumerating }
PvSystemNavigation >> browseMessageList: messageList 
	name: labelString 
	autoSelect: autoSelectString 
	refreshingBlock: aBlock [
	"Create and schedule a MessageSet browser on the message list."
	| methods |
	
	"Do not show trait methods"
	methods := messageList reject: [ :each| each isFromTrait ].
	methods ifEmpty: [
		^ self perspective inform: 'There are no ', String cr, labelString ].
	
	self perspective addWindow: (self application tools messageList new
		messages: methods; 
		title: labelString;
		autoSelect: autoSelectString;
		refreshingBlock: aBlock)
]

{ #category : #accessing }
PvSystemNavigation >> perspective [

	^ perspective
]

{ #category : #accessing }
PvSystemNavigation >> perspective: anObject [

	perspective := anObject
]
