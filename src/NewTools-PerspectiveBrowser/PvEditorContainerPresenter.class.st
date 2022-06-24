Class {
	#name : #PvEditorContainerPresenter,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'editorNotebook'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #accessing }
PvEditorContainerPresenter class >> defaultContainerName [

	^ #edit
]

{ #category : #accessing }
PvEditorContainerPresenter class >> defaultTitle [

	^ 'View'
]

{ #category : #initialization }
PvEditorContainerPresenter >> initializePresenters [ 

	self layout: (SpBoxLayout newTopToBottom
		add: (editorNotebook := self newNotebook);
		yourself)
]
