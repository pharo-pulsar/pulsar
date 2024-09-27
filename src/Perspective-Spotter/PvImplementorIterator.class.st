Class {
	#name : 'PvImplementorIterator',
	#superclass : 'StGenericGenerator',
	#instVars : [
		'environment'
	],
	#category : 'Perspective-Spotter-Model-Processor',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Processor'
}

{ #category : 'instance creation' }
PvImplementorIterator class >> newEnvironment: anEnvironment [

	^ self basicNew
		environment: anEnvironment;
		initialize;
		yourself
]

{ #category : 'enumerating' }
PvImplementorIterator >> elementsDo: aValuable [

	self systemNavigation allBehaviorsDo: [ :aClass | aClass methodsDo: aValuable ]
]

{ #category : 'accessing' }
PvImplementorIterator >> environment [

	^ environment
]

{ #category : 'accessing' }
PvImplementorIterator >> environment: anEnvironment [

	environment := anEnvironment
]

{ #category : 'enumerating' }
PvImplementorIterator >> systemNavigation [

	^ SystemNavigation new 
		environment: self environment;
		yourself
]
