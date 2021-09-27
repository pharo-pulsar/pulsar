Class {
	#name : #StBrowserMethodEditorPresenter,
	#superclass : #StBrowserEditorPresenter,
	#instVars : [
		'codePresenter',
		'toolbarPresenter'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserMethodEditorPresenter class >> type [

	^ #method
]

{ #category : #adding }
StBrowserMethodEditorPresenter >> addToNotebook: aNotebook [

	aNotebook addPage: ((SpNotebookPage   
		title: self model shortName
		icon: (self application iconNamed: #scriptManager) 
		provider: [ self ])
		beCloseable;
		yourself)
]

{ #category : #accessing }
StBrowserMethodEditorPresenter >> content: aString [ 
	
	codePresenter text: aString
]

{ #category : #'actions commands' }
StBrowserMethodEditorPresenter >> doBrowseVersions [
	
	(VersionBrowser 
		newApplication: self application
		model: self model method asRingDefinition)
		openWithSpec
]

{ #category : #'private - actions' }
StBrowserMethodEditorPresenter >> doCompile: aString [

	self model 
		compile: aString 
		notifying: codePresenter interactionModel
]

{ #category : #'private - actions' }
StBrowserMethodEditorPresenter >> doCopyToClipboard [
	
	Clipboard clipboardText: codePresenter text.
	self application inform: ('Copied method {1}' format: { self model shortName })
]

{ #category : #'private - actions' }
StBrowserMethodEditorPresenter >> doReset [

	self updatePresenter
]

{ #category : #initialization }
StBrowserMethodEditorPresenter >> initializePresenters [

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
		whenSubmitDo: [ :aString | self doCompile: aString ];
		whenResetDo: [ self doReset ]

]

{ #category : #testing }
StBrowserMethodEditorPresenter >> isMethodEditor [

	^ true
]

{ #category : #actions }
StBrowserMethodEditorPresenter >> reset [

	codePresenter triggerResetAction
]

{ #category : #actions }
StBrowserMethodEditorPresenter >> submit [
	
	codePresenter triggerSubmitAction
]

{ #category : #accessing }
StBrowserMethodEditorPresenter >> tabPriority [

	^ 100
]

{ #category : #accessing }
StBrowserMethodEditorPresenter >> toolbarActions [
	| group |
	
	group := CmCommandGroup forSpec
		beRoot;
		yourself.

	(StBrowserMethodEditorCommand allCommandsSuchAs: [ :each | each showInToolbar ])
		do: [ :each | group register: (each forSpecContext: self) ].
		
	^ group
]

{ #category : #adding }
StBrowserMethodEditorPresenter >> updateNotebookPage: aPage [

	aPage 
		title: self model shortName;
		beCloseable
]

{ #category : #initialization }
StBrowserMethodEditorPresenter >> updatePresenter [

	codePresenter 
		beForMethod: self model method;
		text: self model sourceCode
]
