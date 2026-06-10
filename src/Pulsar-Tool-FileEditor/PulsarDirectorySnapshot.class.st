Class {
	#name : 'PulsarDirectorySnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'timestamp'
	],
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'restoring' }
PulsarDirectorySnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter lastTimePresented: timestamp
]

{ #category : 'initialization' }
PulsarDirectorySnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	timestamp := aPresenter lastTimePresented
]
