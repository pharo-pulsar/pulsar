Class {
	#name : 'DockEditorSnapshot',
	#superclass : 'DockPanelSnapshot',
	#instVars : [
		'cursorPositionIndex',
		'dirty',
		'timestamp',
		'contents'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
DockEditorSnapshot >> initialize [

	super initialize.
	dirty := false
]

{ #category : 'restoring' }
DockEditorSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter lastTimePresented: timestamp.
	dirty ifTrue: [
		aPresenter editorPresenter text: contents. 
		aPresenter markDirty ].
	aPresenter editorPresenter cursorPositionIndex: cursorPositionIndex
]

{ #category : 'initialization' }
DockEditorSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	dirty := aPresenter isDirty.
	contents := dirty 
		ifTrue: [ aPresenter editorPresenter text ]
		ifFalse: [ nil ].
	timestamp := aPresenter lastTimePresented.
	cursorPositionIndex := aPresenter editorPresenter cursorPositionIndex.

]

{ #category : 'initialization' }
DockEditorSnapshot >> takeModelSnapshot: aPresenter [

	model := aPresenter model prepareForSnapshot
]
