Class {
	#name : #PvFocusUpAction,
	#superclass : #PvAction,
	#category : #'Perspective-Command-Actions'
}

{ #category : #initialization }
PvFocusUpAction >> defineAction [

	self name: 'Focus Up'.
	self description: 'Focus first window up to current focused window'
]

{ #category : #executing }
PvFocusUpAction >> execute [
	
	self context focusUp
]
