Class {
	#name : #PvVirtualPackageTagModel,
	#superclass : #PvEntityModel,
	#instVars : [
		'package'
	],
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #'instance creation' }
PvVirtualPackageTagModel class >> newVirtualModelsFor: aPackage [

	^ self allSubclasses collect: [ :each | each newEntity: aPackage ]
]

{ #category : #comparing }
PvVirtualPackageTagModel >> = other [

	^ self species = other species
		and: [ self package = other package ] 
]

{ #category : #comparing }
PvVirtualPackageTagModel >> hash [

	^ self species hash
		bitXor: self package hash
]

{ #category : #testing }
PvVirtualPackageTagModel >> isRoot [

	^ false
]

{ #category : #accessing }
PvVirtualPackageTagModel >> package [

	^ package
]

{ #category : #accessing }
PvVirtualPackageTagModel >> package: anObject [

	package := anObject
]
