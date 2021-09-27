Class {
	#name : #StBrowserEditorPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserEditorPresenter class >> type [

	^ self subclassResponsibility
]

{ #category : #adding }
StBrowserEditorPresenter >> addToNotebook: aNotebook [

	self subclassResponsibility
]

{ #category : #accessing }
StBrowserEditorPresenter >> content: aString [

	self subclassResponsibility
]

{ #category : #testing }
StBrowserEditorPresenter >> isClassDefinitionEditor [

	^ false
]

{ #category : #testing }
StBrowserEditorPresenter >> isClassEditor [

	^ false
]

{ #category : #testing }
StBrowserEditorPresenter >> isCommentEditor [

	^ false
]

{ #category : #testing }
StBrowserEditorPresenter >> isMethodEditor [

	^ false
]

{ #category : #testing }
StBrowserEditorPresenter >> isPackageEditor [

	^ false
]

{ #category : #testing }
StBrowserEditorPresenter >> isSameAs: anObject [

	^ self species = anObject species
]

{ #category : #replacing }
StBrowserEditorPresenter >> replaceWith: aSimilarEditor [

	self model: aSimilarEditor model
]

{ #category : #actions }
StBrowserEditorPresenter >> reset [

	self subclassResponsibility
]

{ #category : #actions }
StBrowserEditorPresenter >> submit [

	self subclassResponsibility
]

{ #category : #accessing }
StBrowserEditorPresenter >> tabPriority [

	^ self subclassResponsibility
]

{ #category : #accessing }
StBrowserEditorPresenter >> type [

	^ self class type
]

{ #category : #adding }
StBrowserEditorPresenter >> updateNotebookPage: aPage [

	self subclassResponsibility
]
