Class {
	#name : 'DockRepositoryPackageModel',
	#superclass : 'DockRepositoryBaseModel',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'instance creation' }
DockRepositoryPackageModel class >> on: aPackage [

	^ self basicNew
		package: aPackage;
		initialize;
		yourself
]

{ #category : 'accessing' }
DockRepositoryPackageModel >> name [

	^ self package name
]

{ #category : 'accessing' }
DockRepositoryPackageModel >> package [

	^ self entity
]
