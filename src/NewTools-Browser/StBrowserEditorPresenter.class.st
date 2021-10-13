Class {
	#name : #StBrowserEditorPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'dirty'
	],
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

{ #category : #private }
StBrowserEditorPresenter >> dirty: aBoolean [

	dirty := aBoolean
]

{ #category : #initialization }
StBrowserEditorPresenter >> initialize [

	self dirty: false.
	super initialize
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
StBrowserEditorPresenter >> isDirty [

	^ dirty
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

{ #category : #accessing }
StBrowserEditorPresenter >> markDirty [

	self dirty: true
]

{ #category : #replacing }
StBrowserEditorPresenter >> replaceWith: aSimilarEditor [

	self model: aSimilarEditor model
]

{ #category : #actions }
StBrowserEditorPresenter >> reset [

	self subclassResponsibility
]

{ #category : #accessing }
StBrowserEditorPresenter >> resetDirty [

	self dirty: false
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

{ #category : #accessing }
StBrowserEditorPresenter >> windowName [
	
	^ self model windowName
]
