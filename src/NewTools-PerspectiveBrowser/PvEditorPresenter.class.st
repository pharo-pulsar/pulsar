Class {
	#name : #PvEditorPresenter,
	#superclass : #PvPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'#dirty => ObservableSlot',
		'#updating'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #accessing }
PvEditorPresenter class >> type [

	^ self subclassResponsibility
]

{ #category : #'private - building' }
PvEditorPresenter >> buildAdapterWithSpecLayout: aSpecLayout [
	"This is needed because the process of building (and setting initial state) of a 
	 text/code presenter fires the event #whenTextChangedDo: and this will mark the editor 
	 as dirty when it is not, since this is original state."

	^ self updatingWhile: [ 
		super buildAdapterWithSpecLayout: aSpecLayout ]
]

{ #category : #accessing }
PvEditorPresenter >> content: aString [

	self subclassResponsibility
]

{ #category : #private }
PvEditorPresenter >> dirty: aBoolean [

	dirty := aBoolean
]

{ #category : #initialization }
PvEditorPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self title	
]

{ #category : #testing }
PvEditorPresenter >> isClassDefinitionEditor [

	^ false
]

{ #category : #testing }
PvEditorPresenter >> isClassEditor [

	^ false
]

{ #category : #testing }
PvEditorPresenter >> isCommentEditor [

	^ false
]

{ #category : #testing }
PvEditorPresenter >> isDirty [

	^ dirty ifNil: [ dirty := false ]
]

{ #category : #testing }
PvEditorPresenter >> isSameAs: anObject [

	^ self species = anObject species
]

{ #category : #'private - testing' }
PvEditorPresenter >> isUpdating [

	^ updating ifNil: [ updating := false ]
]

{ #category : #accessing }
PvEditorPresenter >> markDirty [

	self isUpdating ifTrue: [ ^ self ].
	self isDirty ifTrue: [ ^ self ].
	self dirty: true
]

{ #category : #accessing }
PvEditorPresenter >> pageTitle [
	
	^ self isDirty 
		ifTrue: [ '*', (self model pageTitle) ]
		ifFalse: [ self model pageTitle ]
]

{ #category : #accessing }
PvEditorPresenter >> replaceWith: aSimilarEditor [

	self updatingWhile: [ 
		self model: aSimilarEditor model ].
	"An editor should not be replaced when is dirty, but in case that happens I need to 
	 start over with a clean state."
	self resetDirty
]

{ #category : #actions }
PvEditorPresenter >> reset [

	self subclassResponsibility
]

{ #category : #accessing }
PvEditorPresenter >> resetDirty [

	self isDirty ifFalse: [ ^ self ].
	self dirty: false
]

{ #category : #actions }
PvEditorPresenter >> submit [

	self subclassResponsibility
]

{ #category : #accessing }
PvEditorPresenter >> tabLabel [

	^ self model shortName
]

{ #category : #accessing }
PvEditorPresenter >> tabPriority [

	^ self subclassResponsibility
]

{ #category : #initialization }
PvEditorPresenter >> title [

	self subclassResponsibility
	
]

{ #category : #accessing }
PvEditorPresenter >> type [

	^ self class type
]

{ #category : #private }
PvEditorPresenter >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : #events }
PvEditorPresenter >> whenDirtyChangedDo: aBlock [

	self property: #dirty whenChangedDo: aBlock
]

{ #category : #accessing }
PvEditorPresenter >> windowTitle [
	
	^ self isDirty 
		ifTrue: [ '*', (self model windowTitle) ]
		ifFalse: [ self model windowTitle ]
]
