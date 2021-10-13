Class {
	#name : #StBrowserMethodEditorPresenter,
	#superclass : #StBrowserEditorPresenter,
	#instVars : [
		'codePresenter',
		'toolbarPresenter',
		'updating'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserMethodEditorPresenter class >> type [

	^ #method
]

{ #category : #adding }
StBrowserMethodEditorPresenter >> addToNotebook: aNotebook [

	aNotebook addPage: (StBrowserEditorPage new   
		title: self model shortName;
		icon: (self application iconNamed: self model windowIconName);
		editor: self;
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
		notifying: codePresenter interactionModel.
		
	self resetDirty
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
StBrowserMethodEditorPresenter >> initialize [

	updating := false.
	super initialize.
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
		whenTextChangedDo: [ self markDirty ];
		whenSubmitDo: [ :aString | self doCompile: aString ];
		whenResetDo: [ self doReset ]
]

{ #category : #testing }
StBrowserMethodEditorPresenter >> isMethodEditor [

	^ true
]

{ #category : #accessing }
StBrowserMethodEditorPresenter >> markDirty [

	updating ifTrue: [ ^ self ].
	self isDirty ifTrue: [ ^ self ].
	super markDirty	
]

{ #category : #actions }
StBrowserMethodEditorPresenter >> reset [

	codePresenter triggerResetAction
]

{ #category : #accessing }
StBrowserMethodEditorPresenter >> resetDirty [

	updating ifTrue: [ ^ self ].
	self isDirty ifFalse: [ ^ self ].
	super resetDirty
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
StBrowserMethodEditorPresenter >> toolbarActionKinds [
	
	^ { StBrowserMethodEditorCommand. StBrowserEditorCommand }
]

{ #category : #accessing }
StBrowserMethodEditorPresenter >> toolbarActions [
	| group |
	
	group := CmCommandGroup forSpec
		beRoot;
		yourself.
		
	self toolbarActionKinds do: [ :each | 
		group register: (self toolbarActionsKind: each) ].
		
	^ group
]

{ #category : #private }
StBrowserMethodEditorPresenter >> toolbarActionsKind: aClass [
	| group |
	
	group := CmCommandGroup forSpec.
	group name: aClass name.
	(aClass allCommandsSuchAs: [ :each | each showInToolbar ])
		do: [ :each | group register: (each forSpecContext: self) ].
	
	^ group
]

{ #category : #emulating }
StBrowserMethodEditorPresenter >> typeByChar: aString [
	"for test purposes"
	
	codePresenter typeByChar: aString
	
]

{ #category : #adding }
StBrowserMethodEditorPresenter >> updateNotebookPage: aPage [

	aPage 
		title: self model shortName;
		icon: (self application iconNamed: self model windowIconName)		
]

{ #category : #initialization }
StBrowserMethodEditorPresenter >> updatePresenter [

	self updatingWhile: [ 
		codePresenter
			beForMethod: self model method;
			text: self model sourceCode ]
]

{ #category : #private }
StBrowserMethodEditorPresenter >> updatingWhile: aBlock [ 

	updating := true.
	aBlock ensure: [ updating := false ]
]
