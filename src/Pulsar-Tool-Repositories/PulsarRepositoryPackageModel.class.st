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

{ #category : 'accessing' }
PulsarRepositoryPackageModel >> name [

	^ self package name
]

{ #category : 'accessing' }
PulsarRepositoryPackageModel >> package [

	^ self entity
]
