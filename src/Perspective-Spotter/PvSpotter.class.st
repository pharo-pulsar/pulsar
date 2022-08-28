Class {
	#name : #PvSpotter,
	#superclass : #LnSpotter,
	#instVars : [
		'perspective'
	],
	#category : #'Perspective-Spotter-View'
}

{ #category : #testing }
PvSpotter class >> isShowingTips [

	^ false
]

{ #category : #initialization }
PvSpotter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: ('Spotter for {1}' format: { self model label })
]

{ #category : #accessing }
PvSpotter >> perspective [
	
	^ perspective
]

{ #category : #accessing }
PvSpotter >> perspective: aPerspective [
	
	perspective := aPerspective
]

{ #category : #processing }
PvSpotter >> startNewProcess [

	self keepLastSelectedEntry.
	self removeAll
]
