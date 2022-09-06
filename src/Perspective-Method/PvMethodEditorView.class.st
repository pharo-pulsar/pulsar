Class {
	#name : #PvMethodEditorView,
	#superclass : #PvEditorView,
	#instVars : [
		'toolbarPresenter',
		'labelPresenter',
		'actionButtonPresenter'
	],
	#category : #'Perspective-Method-View'
}

{ #category : #accessing }
PvMethodEditorView class >> type [

	^ #method
]

{ #category : #initialization }
PvMethodEditorView >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
				add: (SpBoxLayout newLeftToRight
					borderWidth: 3;
					spacing: 3;
					add: actionButtonPresenter expand: false;
					add: labelPresenter;
					yourself);
				addLast: toolbarPresenter expand: false;
				yourself) 
			expand: false;
		add: editorPresenter;
		yourself
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
	self withWindowDo: [ :aWindow |
		aWindow presenter announce: (PvMethodChangedAnnouncement for: self model) ]
]

{ #category : #initialization }
PvMethodEditorView >> initializePresenters [

	super initializePresenters.
	self initializeToolbar.
	actionButtonPresenter := self newButton
		addStyle: 'small';
		addStyle: 'flat';
		enabled: false;
		yourself.
	labelPresenter := self newLabel

]

{ #category : #initialization }
PvMethodEditorView >> initializeToolbar [	

	toolbarPresenter := self buildPerspectiveToolbarWith: [ :builder |
		builder 
			from: PvEditorCommand;
			actionGroups: #(action methodAction) ]
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

{ #category : #accessing }
PvMethodEditorView >> toolbarActions [
	
	^ PvEditorCommand 
		buildToolbar: #(default methodEditor) 
		on: self
]

{ #category : #initialization }
PvMethodEditorView >> updatePresenter [

	super updatePresenter.
	self updateToolbar.
	self updatingWhile: [
		editorPresenter
			beForMethod: self model entity;
			text: self model sourceCode ]
]

{ #category : #initialization }
PvMethodEditorView >> updateToolbar [
		
	self model isTestMethod 
		ifTrue: [  ].
	labelPresenter label: self model methodClassName.
	
]
