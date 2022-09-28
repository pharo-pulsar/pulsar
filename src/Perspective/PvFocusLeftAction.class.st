Class {
	#name : #PvFocusLeftAction,
	#superclass : #PvAction,
	#category : #'Perspective-Command-Actions'
}

{ #category : #initialization }
PvFocusLeftAction >> defineAction [

	self name: 'Focus Left'.
	self description: 'Focus first window left to current focused window'
]

{ #category : #executing }
PvFocusLeftAction >> execute [
	
	self context focusLeft
]
