Class {
	#name : #PvEnvironmentSourceFactory,
	#superclass : #StSourceFactory,
	#instVars : [
		'classIterator',
		'environment',
		'implementorIterator'
	],
	#category : #'Perspective-Spotter-Model-Processor'
}

{ #category : #testing }
PvEnvironmentSourceFactory class >> isAvailable [

	^ false
]

{ #category : #'instance creation' }
PvEnvironmentSourceFactory class >> newEnvironment: anEnvironment [

	^ self new 
		environment: anEnvironment;
		yourself
]

{ #category : #'detecting implementations' }
PvEnvironmentSourceFactory class >> priority [ 
	
	^ 10 
]

{ #category : #accessing }
PvEnvironmentSourceFactory >> classIterator [

	^ classIterator ifNil: [ 
			classIterator := PvClassIterator newEnvironment: self environment ]
]

{ #category : #'sources - classes' }
PvEnvironmentSourceFactory >> classesBeginsWithSource [

	^ ((self classIterator 
		select: [ :each | each isMeta not ])
		collect: [ :each | PvClassEntry on: each ]) 
		asBeginsWithFilter
]

{ #category : #'sources - classes' }
PvEnvironmentSourceFactory >> classesSubstringSource [

	^ ((self classIterator 
		select: [ :each | each isMeta not ])
		collect: [ :each | PvClassEntry on: each ]) 
		asSubstringFilter
]

{ #category : #accessing }
PvEnvironmentSourceFactory >> environment [

	^ environment
]

{ #category : #accessing }
PvEnvironmentSourceFactory >> environment: anEnvironment [

	environment := anEnvironment.
	classIterator := nil.
	implementorIterator := nil
]

{ #category : #accessing }
PvEnvironmentSourceFactory >> implementorIterator [

	^ implementorIterator ifNil:[ 
		implementorIterator := PvImplementorIterator newEnvironment: self environment ]
]

{ #category : #'sources - implementors' }
PvEnvironmentSourceFactory >> implementorsBeginsWithSource [

	^ (self implementorIterator collect: [ :each | PvMethodEntry on: each ]) asBeginsWithFilter
]

{ #category : #'sources - implementors' }
PvEnvironmentSourceFactory >> implementorsSubstringSource [

	^ (self implementorIterator collect: [ :each | PvMethodEntry on: each ]) asSubstringFilter
]
