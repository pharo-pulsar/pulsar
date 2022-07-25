Class {
	#name : #PvViewEntry,
	#superclass : #StEntry,
	#category : #'Perspective-View-Spotter'
}

{ #category : #converting }
PvViewEntry >> asString [ 

	^ content headerBar label
]

{ #category : #evaluating }
PvViewEntry >> doEvaluate [ 

	content takeKeyboardFocus
]

{ #category : #accessing }
PvViewEntry >> icon [
	
	^ content headerBar image
]
