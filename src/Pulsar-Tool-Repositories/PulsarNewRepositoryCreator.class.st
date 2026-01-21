"
New repository creation.
"
Class {
	#name : 'PulsarNewRepositoryCreator',
	#superclass : 'IceRepositoryCreator',
	#instVars : [
		'requestName'
	],
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'actions' }
PulsarNewRepositoryCreator >> createRepository [

	^ self createNewRepositoryNamed: requestName
]

{ #category : 'accessing' }
PulsarNewRepositoryCreator >> requestName: aString [

	requestName := aString
]
