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

{ #category : #testing }
StBrowserEditorPresenter >> isClassEditor [

	^ false
]

{ #category : #testing }
StBrowserEditorPresenter >> isMethodEditor [

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
