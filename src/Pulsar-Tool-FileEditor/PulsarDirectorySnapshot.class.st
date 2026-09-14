"
I am a snapshot for directory presenters. I store the last time the presenter was presented and the expanded items of the directory tree, so expanded branches can be restored after a session restart.
"
Class {
	#name : 'PulsarDirectorySnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'timestamp',
		'expandedItems'
	],
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'accessing' }
PulsarDirectorySnapshot >> expandedItems [

	^ expandedItems
]

{ #category : 'restoring' }
PulsarDirectorySnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter lastTimePresented: timestamp.
	aPresenter expandedItems: expandedItems.
	aPresenter restoreExpandedBranches
]

{ #category : 'initialization' }
PulsarDirectorySnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	timestamp := aPresenter lastTimePresented.
	expandedItems := aPresenter expandedItems asArray
]
