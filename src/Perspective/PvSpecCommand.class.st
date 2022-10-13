Class {
	#name : #PvSpecCommand,
	#superclass : #SpCommand,
	#instVars : [
		'icon'
	],
	#category : #'Perspective-Command-Base'
}

{ #category : #accessing }
PvSpecCommand >> decoratedCommand: aCommand [

	super decoratedCommand: aCommand.
	decoratedCommand specDecorator: self
]

{ #category : #testing }
PvSpecCommand >> hasIcon [

	^ icon notNil or: [ super hasIcon ]
]

{ #category : #accessing }
PvSpecCommand >> icon [

	^ icon ifNil: [ super icon ]
]

{ #category : #accessing }
PvSpecCommand >> icon: anIcon [

	icon := anIcon
]
