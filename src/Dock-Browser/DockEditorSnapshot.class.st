Class {
	#name : 'DockEditorSnapshot',
	#superclass : 'DockPanelSnapshot',
	#instVars : [
		'cursorPositionIndex'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'restoring' }
DockEditorSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter editorPresenter cursorPositionIndex: cursorPositionIndex
]

{ #category : 'initialization' }
DockEditorSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	cursorPositionIndex := aPresenter editorPresenter cursorPositionIndex
]
