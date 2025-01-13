Class {
	#name : 'PvSpotterModelForEnvironment',
	#superclass : 'PvSpotterModel',
	#instVars : [
		'environmentModel'
	],
	#category : 'Perspective-Spotter-Model',
	#package : 'Perspective-Spotter',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvSpotterModelForEnvironment class >> newEnvironment: anEnvironmentModel origin: anOrigin [

	^ self basicNew
		environmentModel: anEnvironmentModel;
		initializeOrigin: anOrigin;
		yourself
]

{ #category : 'accessing' }
PvSpotterModelForEnvironment >> context [

	^ #environment
]

{ #category : 'accessing' }
PvSpotterModelForEnvironment >> environmentModel [

	^ environmentModel
]

{ #category : 'acccessing' }
PvSpotterModelForEnvironment >> environmentModel: anEnvironmentModel [

	environmentModel := anEnvironmentModel
]

{ #category : 'accessing' }
PvSpotterModelForEnvironment >> label [

	^ 'Environment'
]
