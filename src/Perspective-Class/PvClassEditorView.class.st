Class {
	#name : #PvClassEditorView,
	#superclass : #PvEditorView,
	#category : #'Perspective-Class-View'
}

{ #category : #'accessing - actions' }
PvClassEditorView class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #navigation with: { 
		$h mod1 -> PvClassHierarchyNavigationCommand new
	} 
]

{ #category : #accessing }
PvClassEditorView >> content: aString [

	editorPresenter text: aString
]

{ #category : #accessing }
PvClassEditorView >> contextMenuActionGroups [

	^ #(navigation)
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
PvClassEditorView >> initializeEditorHeader [

	super initializeEditorHeader.
	headerPresenter actions: (self actions actionsFor: #navigation)
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
