Class {
	#name : 'DockRepositoriesModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'repositories'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'private' }
DockRepositoriesModel >> collectRepositories [

	^ IceRepository registry collect: [ :each | 
		DockRepositoryModel 
			newEnvironment: self environmentModel 
			parent: self 
			entity: each ]
]

{ #category : 'accessing' }
DockRepositoriesModel >> name [

	^ 'Repositories'
]

{ #category : 'private' }
DockRepositoriesModel >> prepareForSnapshot [

	^ self copy resetRepositories
]

{ #category : 'accessing' }
DockRepositoriesModel >> repositories [

	^ repositories ifNil: [ repositories := self collectRepositories ]
]

{ #category : 'initialization' }
DockRepositoriesModel >> resetRepositories [

	repositories := nil
]
