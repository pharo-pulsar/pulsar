Class {
	#name : #PvSpotter,
	#superclass : #LnSpotter,
	#category : #'Perspective-View-Spotter'
}

{ #category : #testing }
PvSpotter class >> isShowingTips [

	^ false
]

{ #category : #processing }
PvSpotter >> startNewProcess [

	self keepLastSelectedEntry.
	self removeAll
]
