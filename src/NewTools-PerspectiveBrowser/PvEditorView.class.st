Class {
	#name : #PvEditorView,
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
PvEditorView class >> type [

	^ self subclassResponsibility
]

{ #category : #'private - building' }
PvEditorView >> buildAdapterWithSpecLayout: aSpecLayout [
	"This is needed because the process of building (and setting initial state) of a 
	 text/code presenter fires the event #whenTextChangedDo: and this will mark the editor 
	 as dirty when it is not, since this is original state."

	^ self updatingWhile: [ 
		super buildAdapterWithSpecLayout: aSpecLayout ]
]

{ #category : #accessing }
PvEditorView >> content: aString [

	self subclassResponsibility
]

{ #category : #private }
PvEditorView >> dirty: aBoolean [

	dirty := aBoolean
]

{ #category : #private }
PvEditorView >> editorIcon [
	
	^ self iconNamed: self model windowIconName	

]

{ #category : #initialization }
PvEditorView >> initialize [

	super initialize.
	self whenDirtyChangedDo: [ self updateHeader ]
]

{ #category : #initialization }
PvEditorView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self title	
]

{ #category : #testing }
PvEditorView >> isClassDefinitionEditor [

	^ false
]

{ #category : #testing }
PvEditorView >> isClassEditor [

	^ false
]

{ #category : #testing }
PvEditorView >> isCommentEditor [

	^ false
]

{ #category : #testing }
PvEditorView >> isDirty [

	^ dirty ifNil: [ dirty := false ]
]

{ #category : #testing }
PvEditorView >> isSameAs: anObject [

	^ self species = anObject species
]

{ #category : #'private - testing' }
PvEditorView >> isUpdating [

	^ updating ifNil: [ updating := false ]
]

{ #category : #accessing }
PvEditorView >> markDirty [

	self isUpdating ifTrue: [ ^ self ].
	self isDirty ifTrue: [ ^ self ].
	self dirty: true
]

{ #category : #accessing }
PvEditorView >> pageTitle [
	
	^ self isDirty 
		ifTrue: [ '*', (self model pageTitle) ]
		ifFalse: [ self model pageTitle ]
]

{ #category : #accessing }
PvEditorView >> replaceWith: aSimilarEditor [

	self updatingWhile: [ 
		self model: aSimilarEditor model ].
	"An editor should not be replaced when is dirty, but in case that happens I need to 
	 start over with a clean state."
	self resetDirty
]

{ #category : #actions }
PvEditorView >> reset [

	self subclassResponsibility
]

{ #category : #accessing }
PvEditorView >> resetDirty [

	self isDirty ifFalse: [ ^ self ].
	self dirty: false
]

{ #category : #actions }
PvEditorView >> submit [

	self subclassResponsibility
]

{ #category : #accessing }
PvEditorView >> tabLabel [

	^ self model shortName
]

{ #category : #accessing }
PvEditorView >> tabPriority [

	^ self subclassResponsibility
]

{ #category : #initialization }
PvEditorView >> title [

	self subclassResponsibility
	
]

{ #category : #accessing }
PvEditorView >> type [

	^ self class type
]

{ #category : #initialization }
PvEditorView >> updateHeader [

	self withTileWindowDo: [ :w |
		w title: self model shortName.
		w windowIcon: self editorIcon ]
]

{ #category : #initialization }
PvEditorView >> updatePresenter [

	self updateHeader
]

{ #category : #private }
PvEditorView >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : #events }
PvEditorView >> whenDirtyChangedDo: aBlock [

	self property: #dirty whenChangedDo: aBlock
]

{ #category : #accessing }
PvEditorView >> windowTitle [
	
	^ self isDirty 
		ifTrue: [ '*', (self model windowTitle) ]
		ifFalse: [ self model windowTitle ]
]
