Class {
	#name : 'PulsarRepositoryPackageModel',
	#superclass : 'PulsarRepositoryBaseModel',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'instance creation' }
PulsarRepositoryPackageModel class >> on: aPackage [

	^ self basicNew
		package: aPackage;
		initialize;
		yourself
]

{ #category : 'testing' }
PulsarRepositoryPackageModel >> isBaseline [

	^ self name beginsWith: 'BaselineOf'
]

{ #category : 'testing' }
PulsarRepositoryPackageModel >> isLoaded [

	^ self repository isPackageLoaded: self
]

{ #category : 'accessing' }
PulsarRepositoryPackageModel >> name [

	^ self package name
]

{ #category : 'accessing' }
PulsarRepositoryPackageModel >> package [

	^ self entity
]
