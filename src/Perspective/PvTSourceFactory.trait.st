Trait {
	#name : #PvTSourceFactory,
	#instVars : [
		'sourceFactory'
	],
	#category : #'Perspective-Model-Spotter'
}

{ #category : #'instance creation' }
PvTSourceFactory classSide >> newEnvironment: anEnvironment [

	^ self newSourceFactory: (PvEnvironmentSourceFactory newEnvironment: anEnvironment)
]

{ #category : #'instance creation' }
PvTSourceFactory classSide >> newSourceFactory: aSourceFactory [

	^ self basicNew 
		sourceFactory: aSourceFactory;
		initialize;
		yourself
]

{ #category : #accessing }
PvTSourceFactory >> sourceFactory [

	^ sourceFactory
]

{ #category : #accessing }
PvTSourceFactory >> sourceFactory: anObject [

	sourceFactory := anObject
]
