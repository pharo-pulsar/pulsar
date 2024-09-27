Class {
	#name : 'PvGrayIconDecoration',
	#superclass : 'PvIconDecoration',
	#category : 'Perspective-Icon',
	#package : 'Perspective',
	#tag : 'Icon'
}

{ #category : 'operations' }
PvGrayIconDecoration >> applyTo: anIcon [

	^ anIcon asGrayScaleWithAlpha
]

{ #category : 'accessing' }
PvGrayIconDecoration >> name [

	^ 'gray'
]
