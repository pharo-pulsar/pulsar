Class {
	#name : #StVirtualPackageTagModel,
	#superclass : #StBasePackageTagModel,
	#instVars : [
		'package'
	],
	#category : #'NewTools-Browser-Model-Package'
}

{ #category : #'instance creation' }
StVirtualPackageTagModel class >> newPackage: aPackage [

	^ self new 
		package: aPackage;
		yourself
]

{ #category : #'instance creation' }
StVirtualPackageTagModel class >> newVirtualModelsFor: aPackage [

	^ self allSubclasses collect: [ :each | each newPackage: aPackage ]
]

{ #category : #comparing }
StVirtualPackageTagModel >> = other [

	^ self species = other species
		and: [ self package = other package ] 
]

{ #category : #comparing }
StVirtualPackageTagModel >> hash [

	^ self species hash
		bitXor: self package hash
]

{ #category : #accessing }
StVirtualPackageTagModel >> package [

	^ package
]

{ #category : #accessing }
StVirtualPackageTagModel >> package: anObject [

	package := anObject
]
