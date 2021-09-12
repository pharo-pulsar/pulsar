Class {
	#name : #StVirtualPackageTagModel,
	#superclass : #StBasePackageTagModel,
	#instVars : [
		'package'
	],
	#category : #'NewTools-Browser-Model'
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

{ #category : #accessing }
StVirtualPackageTagModel >> package [

	^ package
]

{ #category : #accessing }
StVirtualPackageTagModel >> package: anObject [

	package := anObject
]
