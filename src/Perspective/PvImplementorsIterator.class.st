Class {
	#name : #PvImplementorsIterator,
	#superclass : #StGenericGenerator,
	#instVars : [
		'environment'
	],
	#category : #'Perspective-Model-Spotter'
}

{ #category : #'instance creation' }
PvImplementorsIterator class >> newEnvironment: anEnvironment [

	^ self new
		environment: anEnvironment;
		yourself
]

{ #category : #enumerating }
PvImplementorsIterator >> elementsDo: aValuable [

	self environment allBehaviorsDo: [ :aClass | aClass methodsDo: aValuable ]
]

{ #category : #accessing }
PvImplementorsIterator >> environment [

	^ environment
]

{ #category : #accessing }
PvImplementorsIterator >> environment: anEnvironment [

	environment := anEnvironment
]
