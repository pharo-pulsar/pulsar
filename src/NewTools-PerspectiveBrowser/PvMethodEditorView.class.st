Class {
	#name : #PvMethodEditorView,
	#superclass : #PvEditorView,
	#instVars : [
		'codePresenter',
		'toolbarPresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Method'
}

{ #category : #accessing }
PvMethodEditorView class >> type [

	^ #method
]

{ #category : #accessing }
PvMethodEditorView >> content: aString [ 
	
	self updatingWhile: [ 
		codePresenter text: aString ]
]

{ #category : #accessing }
PvMethodEditorView >> defaultKeyboardFocus [

	^ codePresenter
]

{ #category : #'actions commands' }
PvMethodEditorView >> doBrowseVersions [

	(VersionBrowser
		 newApplication: self application
		 model: self model entity asRingDefinition) open
]

{ #category : #'private - actions' }
PvMethodEditorView >> doCompile: aString [

	self model 
		compile: aString 
		notifying: codePresenter interactionModel.
		
	self resetDirty
]

{ #category : #'private - actions' }
PvMethodEditorView >> doCopyToClipboard [
	
	Clipboard clipboardText: codePresenter text.
	self application inform: ('Copied method {1}' format: { self model shortName })
]

{ #category : #'private - actions' }
PvMethodEditorView >> doReset [
	
	self updatePresenter.
	self resetDirty
]

{ #category : #private }
PvMethodEditorView >> editorIcon [
	| icon |
	
	icon := self iconNamed: (self model windowIconName).
	^ self isDirty 
		ifTrue: [ icon mergeBottomRightWith: (self iconNamed: #overlayDirty) ]
		ifFalse: [ icon ]
]

{ #category : #initialization }
PvMethodEditorView >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
				addLast: (toolbarPresenter := self newToolbar) expand: false;
				yourself) 
			expand: false;
		add: (codePresenter := self newCode);
		yourself).

	toolbarPresenter 
		displayMode: self application toolbarDisplayMode;
		addStyle: 'stToolbar';
		fillWith: self toolbarActions.
		
	codePresenter
		addStyle: 'stCode';
		whenTextChangedDo: [ :newText :oldText | self textChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doCompile: aString ];
		whenResetDo: [ self doReset ]
]

{ #category : #initialization }
PvMethodEditorView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model shortName;
		windowIcon: (self iconNamed: self model windowIconName)
]

{ #category : #actions }
PvMethodEditorView >> reset [

	codePresenter triggerResetAction
]

{ #category : #actions }
PvMethodEditorView >> submit [
	
	codePresenter triggerSubmitAction
]

{ #category : #accessing }
PvMethodEditorView >> tabPriority [

	^ 100
]

{ #category : #private }
PvMethodEditorView >> textChangedFrom: oldText to: newText [

	oldText = newText ifTrue: [ ^ self ].
	self markDirty
]

{ #category : #initialization }
PvMethodEditorView >> title [

	^ self model ifNotNil: #shortName
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

{ #category : #emulating }
PvMethodEditorView >> typeByChar: aString [
	"for test purposes"
	
	codePresenter typeByChar: aString
	
]

{ #category : #initialization }
PvMethodEditorView >> updatePresenter [

	super updatePresenter.
	self updatingWhile: [ 
		codePresenter
			beForMethod: self model entity;
			text: self model sourceCode ].
	
]
