Class {
	#name : #PvClassIterator,
	#superclass : #StGenericGenerator,
	#instVars : [
		'environment'
	],
	#category : #'Perspective-Spotter-Model-Processor'
}

{ #category : #'instance creation' }
PvClassIterator class >> newEnvironment: anEnvironment [

	^ self basicNew
		environment: anEnvironment;
		initialize;
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
