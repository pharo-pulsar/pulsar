Class {
	#name : 'PulsarProjectSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing' }
PulsarProjectSnapshot >> model [

	^ model
]

{ #category : 'restoring' }
PulsarProjectSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter
]

{ #category : 'initialization' }
PulsarProjectSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	model := aPresenter model
]
