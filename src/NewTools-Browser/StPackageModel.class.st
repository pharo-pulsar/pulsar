Class {
	#name : #StPackageModel,
	#superclass : #StBasePackageModel,
	#instVars : [
		'package'
	],
	#category : #'NewTools-Browser-Model'
}

{ #category : #'instance creation' }
StPackageModel class >> newPackage: aPackage [

	^ self new 
		package: aPackage;
		yourself
]

{ #category : #comparing }
StPackageModel >> = other [

	^ self species = other species 
		and: [ self package = other package ]
]

{ #category : #accessing }
StPackageModel >> children [

	^ ((self package classTags 
		reject: [ :each | each name = self name ]) 
		collect: [ :each | StPackageTagModel newPackageTag: each ]
		as: OrderedCollection)
		addAll: (StVirtualPackageTagModel newVirtualModelsFor: self package);
		yourself
]

{ #category : #accessing }
StPackageModel >> classes [

	^ self package definedClasses
		collect: [ :each | StClassModel newClass: each ]
		as: OrderedCollection
]

{ #category : #comparing }
StPackageModel >> hash [ 

	^ self species hash 
		bitXor: self package hash
]

{ #category : #accessing }
StPackageModel >> iconName [

	^ #package
	
]

{ #category : #accessing }
StPackageModel >> name [

	^ self package packageName
]

{ #category : #accessing }
StPackageModel >> package [

	^ package
]

{ #category : #accessing }
StPackageModel >> package: anObject [

	package := anObject
]
