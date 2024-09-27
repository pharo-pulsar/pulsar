Trait {
	#name : 'PvTSourceFactory',
	#instVars : [
		'sourceFactory'
	],
	#category : 'Perspective-Spotter-Model-Processor',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Processor'
}

{ #category : 'instance creation' }
PvTSourceFactory classSide >> newEnvironment: anEnvironment [

	^ self newSourceFactory: (PvEnvironmentSourceFactory newEnvironment: anEnvironment)
]

{ #category : 'instance creation' }
PvTSourceFactory classSide >> newSourceFactory: aSourceFactory [

	^ self basicNew 
		sourceFactory: aSourceFactory;
		initialize;
		yourself
]

{ #category : 'accessing' }
PvTSourceFactory >> sourceFactory [

	^ sourceFactory
]

{ #category : 'accessing' }
PvTSourceFactory >> sourceFactory: anObject [

	sourceFactory := anObject
]
