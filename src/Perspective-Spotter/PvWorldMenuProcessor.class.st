Class {
	#name : 'PvWorldMenuProcessor',
	#superclass : 'StWorldMenuProcessor',
	#instVars : [
		'sourceFactory'
	],
	#category : 'Perspective-Spotter-Model-Processor',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Processor'
}

{ #category : 'instance creation' }
PvWorldMenuProcessor class >> newEnvironment: anEnvironment [

	^ self newSourceFactory: (PvEnvironmentSourceFactory newEnvironment: anEnvironment)
]

{ #category : 'instance creation' }
PvWorldMenuProcessor class >> newSourceFactory: aSourceFactory [

	^ self basicNew 
		sourceFactory: aSourceFactory;
		initialize;
		yourself
]

{ #category : 'accessing' }
PvWorldMenuProcessor >> sourceFactory [

	^ sourceFactory
]

{ #category : 'accessing' }
PvWorldMenuProcessor >> sourceFactory: aSourceFactory [

	sourceFactory := aSourceFactory
]
