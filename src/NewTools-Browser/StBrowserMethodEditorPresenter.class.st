Class {
	#name : #StBrowserMethodEditorPresenter,
	#superclass : #StBrowserEditorPresenter,
	#instVars : [
		'codePresenter'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #adding }
StBrowserMethodEditorPresenter >> addToNotebook: aNotebook [

	aNotebook addPage: (SpNotebookPage   
		title: self model name 
		provider: [ self ])
]

{ #category : #initialization }
StBrowserMethodEditorPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (codePresenter := self newCode);
		yourself)

]

{ #category : #testing }
StBrowserMethodEditorPresenter >> isMethodEditor [

	^ true
]

{ #category : #initialization }
StBrowserMethodEditorPresenter >> updatePresenter [

	codePresenter 
		beForMethod: self model method;
		text: self model sourceCode
]
