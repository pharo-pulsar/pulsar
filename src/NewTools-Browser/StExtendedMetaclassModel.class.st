Class {
	#name : #StExtendedMetaclassModel,
	#superclass : #StMetaclassModel,
	#instVars : [
		'package'
	],
	#category : #'NewTools-Browser-Model-Class'
}

{ #category : #'instance creation' }
StExtendedMetaclassModel class >> newClass: aClass package: aPackage [

	^ (self newClass: aClass)
		package: aPackage;
		yourself
]

{ #category : #accessing }
StExtendedMetaclassModel >> package [

	^ package
]

{ #category : #accessing }
StExtendedMetaclassModel >> package: anObject [

	package := anObject
]
