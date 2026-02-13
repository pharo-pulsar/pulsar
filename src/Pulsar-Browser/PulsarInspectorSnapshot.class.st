Class {
	#name : 'PulsarInspectorSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'timestamp'
	],
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'restoring' }
PulsarInspectorSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter lastTimePresented: timestamp
]

{ #category : 'initialization' }
PulsarInspectorSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	timestamp := aPresenter lastTimePresented
]
