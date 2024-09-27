Class {
	#name : 'PvIconDecoration',
	#superclass : 'Object',
	#category : 'Perspective-Icon',
	#package : 'Perspective',
	#tag : 'Icon'
}

{ #category : 'operations' }
PvIconDecoration >> applyTo: anIcon [

	^ anIcon
]

{ #category : 'operations' }
PvIconDecoration >> applyTo: anIcon on: anApplication [

	^ self applyTo: anIcon
]

{ #category : 'accessing' }
PvIconDecoration >> name [

	^ self subclassResponsibility
]
