Class {
	#name : 'PulsarEditorSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'cursorPositionIndex',
		'dirty',
		'timestamp',
		'contents'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
PulsarEditorSnapshot >> initialize [

	super initialize.
	dirty := false
]

{ #category : 'restoring' }
PulsarEditorSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter lastTimePresented: timestamp.
	dirty ifTrue: [
		aPresenter editorPresenter text: contents. 
		aPresenter markDirty ].
	aPresenter editorPresenter cursorPositionIndex: cursorPositionIndex
]

{ #category : 'initialization' }
PulsarEditorSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	dirty := aPresenter isDirty.
	contents := dirty 
		ifTrue: [ aPresenter editorPresenter text ]
		ifFalse: [ nil ].
	timestamp := aPresenter lastTimePresented.
	cursorPositionIndex := aPresenter editorPresenter cursorPositionIndex.

]

{ #category : 'initialization' }
PulsarEditorSnapshot >> takeModelSnapshot: aPresenter [

	model := aPresenter model prepareForSnapshot
]
