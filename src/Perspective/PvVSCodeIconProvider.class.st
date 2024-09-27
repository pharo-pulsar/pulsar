Class {
	#name : 'PvVSCodeIconProvider',
	#superclass : 'SpLocationIconProvider',
	#instVars : [
		'application'
	],
	#category : 'Perspective-Icon',
	#package : 'Perspective',
	#tag : 'Icon'
}

{ #category : 'accessing' }
PvVSCodeIconProvider >> application [

	^ application
]

{ #category : 'accessing' }
PvVSCodeIconProvider >> application: anObject [

	application := anObject
]

{ #category : 'accessing' }
PvVSCodeIconProvider >> iconNamed: aName ifAbsent: aBlock [

	aName isSymbol ifTrue: [ ^ aBlock value ].
	aName ifNil: [ ^ aBlock value ].

	^super iconNamed: aName ifAbsent: [ nil ]
]

{ #category : 'testing' }
PvVSCodeIconProvider >> isDarkTheme [

	^ self application configuration isDarkTheme
]

{ #category : 'utilities' }
PvVSCodeIconProvider >> loadIconNamed: aSymbol [
	| themeDir |
	
	themeDir := self isDarkTheme 
		ifTrue: [ 'dark' ]
		ifFalse: [ 'light' ].
	self locations do: [ :each | | ref |
		ref := (each / themeDir / aSymbol) withExtension: 'png'.
		ref exists ifTrue: [ 
			^ self loadIcon: ref ] ].
	^ nil
]
