Class {
	#name : 'PvNewClassTemplate',
	#superclass : 'Object',
	#instVars : [
		'parentModel'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'helpers' }
PvNewClassTemplate >> classDefinitionString [

	^ self parentModel classDefinitionString
]

{ #category : 'class - compatibility' }
PvNewClassTemplate >> classSide [

	^ self class
]

{ #category : 'accessing' }
PvNewClassTemplate >> comment [

	^ 'Comment me!'
]

{ #category : 'accessing' }
PvNewClassTemplate >> compilerClass [
	
	^ Smalltalk compilerClass
]

{ #category : 'class - compatibility' }
PvNewClassTemplate >> instanceSide [

	^ self class
]

{ #category : 'testing' }
PvNewClassTemplate >> isAbstract [
	
	^ false
]

{ #category : 'testing' }
PvNewClassTemplate >> isTestCase [

	^ false
]

{ #category : 'accessing' }
PvNewClassTemplate >> name [
	
	^ 'New class'
]

{ #category : 'accessing' }
PvNewClassTemplate >> package [
	
	^ self parentModel package
]

{ #category : 'accessing' }
PvNewClassTemplate >> packageName [
	
	^ self package name
]

{ #category : 'accessing' }
PvNewClassTemplate >> packageTag [
	
	^ self parentModel entity
]

{ #category : 'accessing' }
PvNewClassTemplate >> packageTagName [
	
	^ self packageTag name
]

{ #category : 'accessing' }
PvNewClassTemplate >> parentModel [

	^ parentModel
]

{ #category : 'accessing' }
PvNewClassTemplate >> parentModel: aPackageOrTag [

	parentModel := aPackageOrTag
]
