Class {
	#name : 'DockEditorSnapshot',
	#superclass : 'DockPanelSnapshot',
	#instVars : [
		'model',
		'cursorPositionIndex'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing' }
DockEditorSnapshot >> model [

	^ model
]

{ #category : 'restoring' }
DockEditorSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter editorPresenter cursorPositionIndex: cursorPositionIndex
]

{ #category : 'initialization' }
DockEditorSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	model := aPresenter model.
	cursorPositionIndex := aPresenter editorPresenter cursorPositionIndex
]
