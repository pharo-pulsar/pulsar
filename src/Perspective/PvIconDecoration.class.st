Class {
	#name : #PvIconDecoration,
	#superclass : #Object,
	#category : #'Perspective-Icon'
}

{ #category : #operations }
PvIconDecoration >> applyTo: anIcon [

	^ anIcon
]

{ #category : #operations }
PvIconDecoration >> applyTo: anIcon on: anApplication [

	^ self applyTo: anIcon
]
