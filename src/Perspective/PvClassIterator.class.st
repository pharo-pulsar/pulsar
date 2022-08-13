Class {
	#name : #PvClassIterator,
	#superclass : #StGenericGenerator,
	#instVars : [
		'environment'
	],
	#category : #'Perspective-Model-Spotter'
}

{ #category : #'instance creation' }
PvClassIterator class >> newEnvironment: anEnvironment [

	^ self new 
		environment: anEnvironment;
		yourself
]

{ #category : #enumerating }
PvClassIterator >> elementsDo: aValuable [

	self systemNavigation allBehaviorsDo: aValuable
]

{ #category : #accessing }
PvClassIterator >> environment [
		
	^ environment
]

{ #category : #accessing }
PvClassIterator >> environment: anEnvironment [

	environment := anEnvironment
]

{ #category : #accessing }
PvClassIterator >> systemNavigation [

	^ SystemNavigation new
		environment: self environment;
		yourself
]
