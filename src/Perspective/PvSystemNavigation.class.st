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

{ #category : #'as yet unclassified' }
PvSystemNavigation >> browse: anObject [

	self flag: #TODO. "See if this is enough or better with a double dispatch"
	anObject isCompiledMethod ifTrue: [
		self perspective activateMethod: anObject.
		^ self ].
		
	self perspective activateClass: anObject class instanceSide
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
PvSystemNavigation >> browseVersionsOf: aMethod [ 

	(self application tools versionBrowser
		newApplication: self application
		model: aMethod asRingDefinition) 
		open
]

{ #category : #'as yet unclassified' }
PvSystemNavigation >> inspect: anObject [

	self application tools inspector inspect: anObject
]

{ #category : #accessing }
PvSystemNavigation >> perspective [

	^ perspective
]

{ #category : #accessing }
PvSystemNavigation >> perspective: anObject [

	perspective := anObject
]
