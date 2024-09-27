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
