Class {
	#name : 'PvLocationWithThemeIconProvider',
	#superclass : 'SpLocationIconProvider',
	#instVars : [
		'application'
	],
	#category : 'Perspective-Icon',
	#package : 'Perspective',
	#tag : 'Icon'
}

{ #category : 'accessing' }
PvLocationWithThemeIconProvider >> application [

	^ application
]

{ #category : 'accessing' }
PvLocationWithThemeIconProvider >> application: anObject [

	application := anObject
]

{ #category : 'accessing' }
PvLocationWithThemeIconProvider >> iconNamed: aName ifAbsent: aBlock [
	| icon |

	aName isSymbol ifTrue: [ ^ aBlock value ].
	aName ifNil: [ ^ aBlock value ].

	icon := nil.
	self isDarkTheme ifTrue: [ 
		icon := super iconNamed: aName, '_dark' ifAbsent: [ nil ] ].
	icon ifNil: [ 
		icon := super iconNamed: aName ifAbsent: [ nil ] ].
	
	^ icon ifNil: [ aBlock value ]
	
]

{ #category : 'testing' }
PvLocationWithThemeIconProvider >> isDarkTheme [

	^ self application configuration isDarkTheme
]
