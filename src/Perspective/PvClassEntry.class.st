Class {
	#name : #PvClassEntry,
	#superclass : #StClassEntry,
	#category : #'Perspective-Model-Spotter'
}

{ #category : #evaluating }
PvClassEntry >> evaluateFor: aSpotter [

	aSpotter perspective activateClass: self content
]
