Class {
	#name : #StExtendedClassModel,
	#superclass : #StClassModel,
	#instVars : [
		'package'
	],
	#category : #'NewTools-Browser-Model-Class'
}

{ #category : #'instance creation' }
StExtendedClassModel class >> newClass: aClass package: aPackage [

	^ (self newClass: aClass)
		package: aPackage;
		yourself
]

{ #category : #'accessing - parallel hierarchy' }
StExtendedClassModel >> classSide [

	^ StExtendedMetaclassModel 
		newClass: self modelClass classSide
		package: self package
]

{ #category : #accessing }
StExtendedClassModel >> package [

	^ package
]

{ #category : #accessing }
StExtendedClassModel >> package: anObject [

	package := anObject
]
