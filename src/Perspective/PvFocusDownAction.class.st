Class {
	#name : #PvFocusDownAction,
	#superclass : #PvAction,
	#category : #'Perspective-Command-Actions'
}

{ #category : #initialization }
PvFocusDownAction >> defineAction [

	self name: 'Focus Down'.
	self description: 'Focus first window down to current focused window'
]

{ #category : #executing }
PvFocusDownAction >> execute [
	
	self context focusDown
]
