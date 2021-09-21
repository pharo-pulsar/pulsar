Class {
	#name : #StBrowserMethodEditorPresenter,
	#superclass : #StBrowserEditorPresenter,
	#instVars : [
		'codePresenter'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserMethodEditorPresenter class >> type [

	^ #method
]

{ #category : #adding }
StBrowserMethodEditorPresenter >> addToNotebook: aNotebook [

	aNotebook addPage: ((SpNotebookPage   
		title: self model shortName
		icon: (self application iconNamed: #scriptManager) 
		provider: [ self ])
		beCloseable;
		yourself)
]

{ #category : #initialization }
StBrowserMethodEditorPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (codePresenter := self newCode);
		yourself).
		
	codePresenter
		whenSubmitDo: [ :aString | self halt ];
		whenResetDo: [ self halt ]

]

{ #category : #testing }
StBrowserMethodEditorPresenter >> isMethodEditor [

	^ true
]

{ #category : #accessing }
StBrowserMethodEditorPresenter >> tabPriority [

	^ 100
]

{ #category : #adding }
StBrowserMethodEditorPresenter >> updateNotebookPage: aPage [

	aPage 
		title: self model shortName;
		beCloseable
]

{ #category : #initialization }
StBrowserMethodEditorPresenter >> updatePresenter [

	codePresenter 
		beForMethod: self model method;
		text: self model sourceCode
]
