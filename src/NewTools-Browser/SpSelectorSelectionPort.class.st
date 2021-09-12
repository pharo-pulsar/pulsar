Class {
	#name : #SpSelectorSelectionPort,
	#superclass : #SpSelectionPort,
	#instVars : [
		'selector'
	],
	#category : #'NewTools-Browser-Port'
}

{ #category : #'instance creation' }
SpSelectorSelectionPort class >> newPresenter: aPresenter selector: aSelector [

	^ (self newPresenter: aPresenter)
		selector: aSelector;
		yourself
]

{ #category : #attaching }
SpSelectorSelectionPort >> attachTransmission: aTransmission to: aPresenter [
		
	aPresenter 
		perform: selector 
		with: [ :selection | 
			self 
				transmitWith: aTransmission 
				value: (self applyTransform: selection transmission) ]
]

{ #category : #accessing }
SpSelectorSelectionPort >> selector: aSelector [

	selector := aSelector
]
