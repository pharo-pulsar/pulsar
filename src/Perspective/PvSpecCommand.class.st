Class {
	#name : #PvSpecCommand,
	#superclass : #SpCommand,
	#instVars : [
		'icon'
	],
	#category : #'Perspective-Command'
}

{ #category : #accessing }
PvSpecCommand >> icon [

	^ icon ifNil: [ super icon ]
]

{ #category : #accessing }
PvSpecCommand >> icon: anIcon [

	icon := anIcon
]
