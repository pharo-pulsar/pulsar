Class {
	#name : 'PulsarRepositoriesModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'repositories'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarRepositoriesModel class >> on: aSystemEnvironmentModel [

	^ self 
		newEnvironment: aSystemEnvironmentModel
		parent: aSystemEnvironmentModel
		entity: nil
]

{ #category : 'private' }
PulsarRepositoriesModel >> collectRepositories [

	^ IceRepository registry collect: [ :each | 
		PulsarRepositoryModel 
			newEnvironment: self environmentModel 
			parent: self 
			entity: each ]
]

{ #category : 'accessing' }
PulsarRepositoriesModel >> name [

	^ 'Repositories'
]

{ #category : 'private' }
PulsarRepositoriesModel >> prepareForSnapshot [

	^ self copy resetRepositories
]

{ #category : 'accessing' }
PulsarRepositoriesModel >> repositories [

	^ repositories ifNil: [ repositories := self collectRepositories ]
]

{ #category : 'initialization' }
PulsarRepositoriesModel >> resetRepositories [

	repositories := nil
]
