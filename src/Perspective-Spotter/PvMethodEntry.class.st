Class {
	#name : 'PvMethodEntry',
	#superclass : 'StMethodEntry',
	#category : 'Perspective-Spotter-Model-Entry',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Entry'
}

{ #category : 'evaluating' }
PvMethodEntry >> evaluateFor: aSpotter [

	aSpotter perspective activateMethod: self content
]
