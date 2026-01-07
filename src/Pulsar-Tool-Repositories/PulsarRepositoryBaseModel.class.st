Class {
	#name : 'PulsarRepositoryBaseModel',
	#superclass : 'Object',
	#traits : 'PulsarTModel',
	#classTraits : 'PulsarTModel classTrait',
	#instVars : [
		'repository',
		'entity'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'instance creation' }
PulsarRepositoryBaseModel class >> newRepository: aRepositoryModel entity: anObject [

	^ self basicNew 
		repository: aRepositoryModel;
		entity: anObject;
		initialize;
		yourself  
]

{ #category : 'accessing' }
PulsarRepositoryBaseModel >> entity [

	^ entity
]

{ #category : 'initialize' }
PulsarRepositoryBaseModel >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing' }
PulsarRepositoryBaseModel >> repository [

	^ repository
]

{ #category : 'initialize' }
PulsarRepositoryBaseModel >> repository: aRepositoryModel [

	repository := aRepositoryModel
]
