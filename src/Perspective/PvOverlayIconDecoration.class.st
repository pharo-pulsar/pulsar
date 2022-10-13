Class {
	#name : #PvOverlayIconDecoration,
	#superclass : #PvIconDecoration,
	#instVars : [
		'position',
		'overlay'
	],
	#category : #'Perspective-Icon'
}

{ #category : #operations }
PvOverlayIconDecoration >> applyTo: icon on: anApplication [
	| overlayIcon |
	
	overlayIcon :=  anApplication iconNamed: self overlay.
	position = #topLeft 		ifTrue: [ ^ icon mergeWith: overlayIcon ].
	position = #topRight 		ifTrue: [ ^ icon mergeTopRightWith: overlayIcon ].	
	position = #bottomLeft 	ifTrue: [ ^ icon mergeBottomLeftWith: overlayIcon ].
	position = #bottomRight 	ifTrue: [ ^ icon mergeBottomRightWith: overlayIcon ].	
	
	self error: 'Should not arrive here'
]

{ #category : #accessing }
PvOverlayIconDecoration >> overlay [

	^ overlay
]

{ #category : #accessing }
PvOverlayIconDecoration >> overlay: aName [

	overlay := aName
]

{ #category : #accessing }
PvOverlayIconDecoration >> position [

	^ position
]

{ #category : #accessing }
PvOverlayIconDecoration >> position: anObject [

	position := anObject
]
