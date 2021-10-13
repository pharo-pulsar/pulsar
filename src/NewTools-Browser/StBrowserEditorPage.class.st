Class {
	#name : #StBrowserEditorPage,
	#superclass : #SpNotebookPage,
	#instVars : [
		'editorPresenter'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserEditorPage >> editor [

	^ editorPresenter
]

{ #category : #accessing }
StBrowserEditorPage >> editor: aPresenter [

	editorPresenter := aPresenter
]

{ #category : #accessing }
StBrowserEditorPage >> presenterProvider [

	^ editorPresenter
]
