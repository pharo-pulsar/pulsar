Class {
	#name : #PvGrayIconDecoration,
	#superclass : #PvIconDecoration,
	#category : #'Perspective-Icon'
}

{ #category : #operations }
PvGrayIconDecoration >> applyTo: anIcon [

	^ anIcon asGrayScaleWithAlpha
]
