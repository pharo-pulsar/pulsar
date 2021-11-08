Class {
	#name : #StBrowserEditorPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'#dirty => ObservableSlot',
		'#updating'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserEditorPresenter class >> type [

	^ self subclassResponsibility
]

{ #category : #'accessing - editor' }
StBrowserEditorPresenter >> addToNotebook: aNotebook [

	self subclassResponsibility
]

{ #category : #'private - building' }
StBrowserEditorPresenter >> buildAdapterWithSpecLayout: aSpecLayout [
	"This is needed because the process of building (and setting initial state) of a 
	 text/code presenter fires the event #whenTextChangedDo: and this will mark the editor 
	 as dirty when it is not, since this is original state."

	^ self updatingWhile: [ 
		super buildAdapterWithSpecLayout: aSpecLayout ]
]

{ #category : #accessing }
StBrowserEditorPresenter >> content: aString [

	self subclassResponsibility
]

{ #category : #private }
StBrowserEditorPresenter >> dirty: aBoolean [

	dirty := aBoolean
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

	^ dirty ifNil: [ dirty := false ]
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

{ #category : #'private - testing' }
StBrowserEditorPresenter >> isUpdating [

	^ updating ifNil: [ updating := false ]
]

{ #category : #accessing }
StBrowserEditorPresenter >> markDirty [

	self isUpdating ifTrue: [ ^ self ].
	self isDirty ifTrue: [ ^ self ].
	self dirty: true
]

{ #category : #accessing }
StBrowserEditorPresenter >> pageTitle [
	
	^ self isDirty 
		ifTrue: [ '*', (self model pageTitle) ]
		ifFalse: [ self model pageTitle ]
]

{ #category : #accessing }
StBrowserEditorPresenter >> replaceWith: aSimilarEditor [

	self updatingWhile: [ 
		self model: aSimilarEditor model ].
	"An editor should not be replaced when is dirty, but in case that happens I need to 
	 start over with a clean state."
	self resetDirty
]

{ #category : #actions }
StBrowserEditorPresenter >> reset [

	self subclassResponsibility
]

{ #category : #accessing }
StBrowserEditorPresenter >> resetDirty [

	self isDirty ifFalse: [ ^ self ].
	self dirty: false
]

{ #category : #actions }
StBrowserEditorPresenter >> submit [

	self subclassResponsibility
]

{ #category : #accessing }
StBrowserEditorPresenter >> tabLabel [

	^ self model shortName
]

{ #category : #accessing }
StBrowserEditorPresenter >> tabPriority [

	^ self subclassResponsibility
]

{ #category : #accessing }
StBrowserEditorPresenter >> type [

	^ self class type
]

{ #category : #'accessing - editor' }
StBrowserEditorPresenter >> updateNotebookPage: aPage [

	self subclassResponsibility
]

{ #category : #private }
StBrowserEditorPresenter >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : #events }
StBrowserEditorPresenter >> whenDirtyChangedDo: aBlock [

	self property: #dirty whenChangedDo: aBlock
]

{ #category : #accessing }
StBrowserEditorPresenter >> windowTitle [
	
	^ self isDirty 
		ifTrue: [ '*', (self model windowTitle) ]
		ifFalse: [ self model windowTitle ]
]
