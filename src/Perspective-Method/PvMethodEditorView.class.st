Class {
	#name : #PvMethodEditorView,
	#superclass : #PvEditorView,
	#instVars : [
		'toolbarPresenter',
		'labelPresenter'
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
					add: labelPresenter;
					yourself);
				addLast: toolbarPresenter expand: false;
				yourself) 
			expand: false;
		add: editorPresenter;
		yourself
]

{ #category : #'actions commands' }
PvMethodEditorView >> doBrowseVersions [

	(VersionBrowser
		 newApplication: self application
		 model: self model entity asRingDefinition) open
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
	labelPresenter := self newLabel

]

{ #category : #initialization }
PvMethodEditorView >> initializeToolbar [	

	(toolbarPresenter := self newToolbar)
		"displayMode: self application toolbarDisplayMode;"
		beIcons;
		addStyle: 'stToolbar';
		fillWith: self toolbarActions
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
PvMethodEditorView >> toolbarActionKinds [
	
	^ { StBrowserMethodEditorCommand. StBrowserEditorCommand }
]

{ #category : #accessing }
PvMethodEditorView >> toolbarActions [
	| group |
	
	group := CmCommandGroup forSpec
		beRoot;
		yourself.
		
	self toolbarActionKinds do: [ :each | 
		group register: (self toolbarActionsKind: each) ].
		
	^ group
]

{ #category : #private }
PvMethodEditorView >> toolbarActionsKind: aClass [
	| group |
	
	group := CmCommandGroup forSpec.
	group name: aClass name.
	(aClass allCommandsSuchAs: [ :each | each showInToolbar ])
		do: [ :each | group register: (each forSpecContext: self) ].
	
	^ group
]

{ #category : #initialization }
PvMethodEditorView >> updatePresenter [

	super updatePresenter.
	labelPresenter label: self model fullName.
	self updatingWhile: [
		editorPresenter
			beForMethod: self model entity;
			text: self model sourceCode ]
]
