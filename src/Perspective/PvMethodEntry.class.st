Class {
	#name : #PvMethodEntry,
	#superclass : #StMethodEntry,
	#category : #'Perspective-Model-Spotter'
}

{ #category : #evaluating }
PvMethodEntry >> evaluateFor: aSpotter [

	aSpotter perspective activateMethod: self content
]
