Class {
	#name : #StBrowserClassCommentPresenter,
	#superclass : #StBrowserEditorPresenter,
	#instVars : [
		'commentTextPresenter'
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
		add: (commentTextPresenter := self newText);
		yourself).
	
	commentTextPresenter addStyle: 'code'
]

{ #category : #testing }
StBrowserClassCommentPresenter >> isClassEditor [

	^ true
]

{ #category : #testing }
StBrowserClassCommentPresenter >> isCommentEditor [
	
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

	commentTextPresenter text: self model comment
]
