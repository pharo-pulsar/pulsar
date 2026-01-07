Class {
	#name : 'PulsarRepositoriesModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'repositories'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

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
