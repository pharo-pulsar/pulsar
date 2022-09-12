Class {
	#name : #PvClassEditorView,
	#superclass : #PvEditorView,
	#category : #'Perspective-Class-View'
}

{ #category : #accessing }
PvClassEditorView >> content: aString [

	editorPresenter text: aString
]

{ #category : #'private - actions' }
PvClassEditorView >> doSubmit: aString [

	self model 
		compile: aString withInternalLineEndings
		notifying: editorPresenter interactionModel.		
	self resetDirty.
	self withPerspectiveDo: [ :aPerspective |
		aPerspective announce: (PvClassChangedAnnouncement for: self model) ]	
]

{ #category : #'as yet unclassified' }
PvClassEditorView >> editorHeaderClass [

	^ PvClassEditorHeaderPresenter
]

{ #category : #initialization }
PvClassEditorView >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	self model ifNotNil: [ :aModel | 
		aWindowPresenter windowIcon: (aModel windowIconComposite buildOn: self application) ]
]

{ #category : #initialization }
PvClassEditorView >> model: aModel [

	super model: aModel.
	headerPresenter model: aModel
]

{ #category : #initialization }
PvClassEditorView >> title [

	^ self model ifNotNil: [ :aModel | aModel windowTitle ]
	
]

{ #category : #initialization }
PvClassEditorView >> updatePresenter [

	super updatePresenter.
	self updatingWhile: [ 
		editorPresenter text: self model classDefinitionString ]
]
