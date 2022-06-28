Class {
	#name : #PvMethodEditorPresenter,
	#superclass : #PvEditorPresenter,
	#instVars : [
		'codePresenter',
		'toolbarPresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Method'
}

{ #category : #accessing }
PvMethodEditorPresenter class >> type [

	^ #method
]

{ #category : #accessing }
PvMethodEditorPresenter >> content: aString [ 
	
	self updatingWhile: [ 
		codePresenter text: aString ]
]

{ #category : #'actions commands' }
PvMethodEditorPresenter >> doBrowseVersions [

	(VersionBrowser
		 newApplication: self application
		 model: self model entity asRingDefinition) open
]

{ #category : #'private - actions' }
PvMethodEditorPresenter >> doCompile: aString [

	self model 
		compile: aString 
		notifying: codePresenter interactionModel.
		
	self resetDirty
]

{ #category : #'private - actions' }
PvMethodEditorPresenter >> doCopyToClipboard [
	
	Clipboard clipboardText: codePresenter text.
	self application inform: ('Copied method {1}' format: { self model shortName })
]

{ #category : #'private - actions' }
PvMethodEditorPresenter >> doReset [

	self updatePresenter
]

{ #category : #initialization }
PvMethodEditorPresenter >> initializePresenters [

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

{ #category : #actions }
PvMethodEditorPresenter >> reset [

	codePresenter triggerResetAction
]

{ #category : #actions }
PvMethodEditorPresenter >> submit [
	
	codePresenter triggerSubmitAction
]

{ #category : #accessing }
PvMethodEditorPresenter >> tabPriority [

	^ 100
]

{ #category : #private }
PvMethodEditorPresenter >> textChangedFrom: oldText to: newText [

	oldText = newText ifTrue: [ ^ self ].
	self markDirty
]

{ #category : #initialization }
PvMethodEditorPresenter >> title [

	^ self model ifNotNil: #shortName
]

{ #category : #accessing }
PvMethodEditorPresenter >> toolbarActionKinds [
	
	^ { StBrowserMethodEditorCommand. StBrowserEditorCommand }
]

{ #category : #accessing }
PvMethodEditorPresenter >> toolbarActions [
	| group |
	
	group := CmCommandGroup forSpec
		beRoot;
		yourself.
		
	self toolbarActionKinds do: [ :each | 
		group register: (self toolbarActionsKind: each) ].
		
	^ group
]

{ #category : #private }
PvMethodEditorPresenter >> toolbarActionsKind: aClass [
	| group |
	
	group := CmCommandGroup forSpec.
	group name: aClass name.
	(aClass allCommandsSuchAs: [ :each | each showInToolbar ])
		do: [ :each | group register: (each forSpecContext: self) ].
	
	^ group
]

{ #category : #emulating }
PvMethodEditorPresenter >> typeByChar: aString [
	"for test purposes"
	
	codePresenter typeByChar: aString
	
]

{ #category : #initialization }
PvMethodEditorPresenter >> updatePresenter [

	self updatingWhile: [ 
		codePresenter
			beForMethod: self model entity;
			text: self model sourceCode ]
]
