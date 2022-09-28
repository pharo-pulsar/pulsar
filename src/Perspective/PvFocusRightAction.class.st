Class {
	#name : #PvFocusRightAction,
	#superclass : #PvAction,
	#category : #'Perspective-Command-Actions'
}

{ #category : #initialization }
PvFocusRightAction >> defineAction [

	self name: 'Focus Right'.
	self description: 'Focus first window right to current focused window'
]

{ #category : #executing }
PvFocusRightAction >> execute [
	
	self context focusRight
]
