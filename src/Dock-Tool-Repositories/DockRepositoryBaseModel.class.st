Class {
	#name : 'DockRepositoryBaseModel',
	#superclass : 'Object',
	#traits : 'DockTModel',
	#classTraits : 'DockTModel classTrait',
	#instVars : [
		'repository',
		'entity'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'instance creation' }
DockRepositoryBaseModel class >> newRepository: aRepositoryModel entity: anObject [

	^ self basicNew 
		repository: aRepositoryModel;
		entity: anObject;
		initialize;
		yourself  
]

{ #category : 'accessing' }
DockRepositoryBaseModel >> entity [

	^ entity
]

{ #category : 'initialize' }
DockRepositoryBaseModel >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing' }
DockRepositoryBaseModel >> repository [

	^ repository
]

{ #category : 'initialize' }
DockRepositoryBaseModel >> repository: aRepositoryModel [

	repository := aRepositoryModel
]
