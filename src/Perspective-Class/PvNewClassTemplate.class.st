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
PvNewClassTemplate >> compilerClass [
	
	^ Smalltalk compilerClass
]

{ #category : 'class - compatibility' }
PvNewClassTemplate >> instanceSide [

	^ self class
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
PvNewClassTemplate >> parentModel [

	^ parentModel
]

{ #category : 'accessing' }
PvNewClassTemplate >> parentModel: aPackageOrTag [

	parentModel := aPackageOrTag
]
