Class {
	#name : #PvMethodEditorView,
	#superclass : #PvEditorView,
	#category : #'Perspective-Method-View'
}

{ #category : #accessing }
PvMethodEditorView class >> type [

	^ #method
]

{ #category : #'private - actions' }
PvMethodEditorView >> doCopyToClipboard [
	
	Clipboard clipboardText: editorPresenter text.
	self application inform: ('Copied method {1}' format: { self model shortName })
]

{ #category : #'private - actions' }
PvMethodEditorView >> doSubmit: aString [
	| oldName |

	oldName := self model name.
	self model 
		compile: aString withInternalLineEndings
		notifying: editorPresenter interactionModel.		
	self resetDirty.
	self withPerspectiveDo: [ :aPerspective |
		aPerspective announce: (PvMethodChangedAnnouncement for: self model) ]
]

{ #category : #private }
PvMethodEditorView >> editorHeaderClass [

	^ PvMethodEditorHeaderPresenter
]

{ #category : #initialization }
PvMethodEditorView >> initializePresenters [

	super initializePresenters
]

{ #category : #initialization }
PvMethodEditorView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model shortName;
		windowIcon: (self model windowIconComposite buildOn: self application)
]

{ #category : #initialization }
PvMethodEditorView >> title [

	^ self model 
		ifNotNil: [ :aModel | aModel windowTitle ]
]

{ #category : #initialization }
PvMethodEditorView >> toolbar [	

	^ self buildPerspectiveToolbarWith: [ :builder |
		builder 
			from: PvEditorCommand;
			actionGroups: #(action methodAction) ]
]

{ #category : #accessing }
PvMethodEditorView >> toolbarActions [
	
	^ PvEditorCommand 
		buildToolbar: #(default methodEditor) 
		on: self
]

{ #category : #initialization }
PvMethodEditorView >> updatePresenter [

	super updatePresenter.
	self updatingWhile: [
		editorPresenter
			beForMethod: self model entity;
			text: self model sourceCode ]
]
