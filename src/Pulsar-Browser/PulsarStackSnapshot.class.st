Class {
	#name : 'PulsarStackSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'sortingSelector'
	],
	#category : 'Pulsar-Browser-View-Stack',
	#package : 'Pulsar-Browser',
	#tag : 'View-Stack'
}

{ #category : 'restoring' }
PulsarStackSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter sortingSelector: sortingSelector
]

{ #category : 'initialization' }
PulsarStackSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	sortingSelector := aPresenter sortingSelector
]
