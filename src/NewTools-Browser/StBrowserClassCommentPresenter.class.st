Class {
	#name : #StBrowserClassCommentPresenter,
	#superclass : #StBrowserEditorPresenter,
	#instVars : [
		'commentText'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserClassCommentPresenter class >> type [

	^ #method
]

{ #category : #adding }
StBrowserClassCommentPresenter >> addToNotebook: aNotebook [

	aNotebook addPage: ((SpNotebookPage   
		title: 'Comment'
		icon: (self application iconNamed: self model commentIconName) 
		provider: [ self ])
		beCloseable;
		yourself)
]

{ #category : #initialization }
StBrowserClassCommentPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (commentText := self newText);
		yourself).
	
	commentText addStyle: 'code'
]

{ #category : #testing }
StBrowserClassCommentPresenter >> isClassEditor [

	^ true
]

{ #category : #accessing }
StBrowserClassCommentPresenter >> tabPriority [

	^ 50
]

{ #category : #adding }
StBrowserClassCommentPresenter >> updateNotebookPage: aPage [

	aPage 
		icon: (self application iconNamed: self model commentIconName)
]

{ #category : #initialization }
StBrowserClassCommentPresenter >> updatePresenter [

	commentText text: self model comment
]
