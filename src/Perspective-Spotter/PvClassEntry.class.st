Class {
	#name : #PvClassEntry,
	#superclass : #StClassEntry,
	#category : #'Perspective-Spotter-Model-Entry'
}

{ #category : #evaluating }
PvClassEntry >> evaluateFor: aSpotter [

	aSpotter perspective activateClass: self content
]
