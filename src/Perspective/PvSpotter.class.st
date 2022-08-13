Class {
	#name : #PvSpotter,
	#superclass : #LnSpotter,
	#category : #'Perspective-View-Spotter'
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

{ #category : #processing }
PvSpotter >> startNewProcess [

	self keepLastSelectedEntry.
	self removeAll
]
