"
I am a snapshot for file presenters. I store the last time the presenter was presented and the expanded items of the directory tree, so expanded branches can be restored after a session restart.
"
Class {
	#name : 'PulsarFileSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'timestamp'
	],
	#category : 'Pulsar-Tool-FileEditor-Utilities',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Utilities'
}

{ #category : 'restoring' }
PulsarFileSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter lastTimePresented: timestamp
]

{ #category : 'initialization' }
PulsarFileSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	timestamp := aPresenter lastTimePresented
]
