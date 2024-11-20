"
A base for all editors.
Being an editor a key component of a perspective (since editing methods and definitions is the base of them), this component defines common behavior for all extensions of it.
"
Class {
	#name : 'PvEditorView',
	#superclass : 'PvPresenter',
	#traits : 'SpTModel + PvTActionHolder',
	#classTraits : 'SpTModel classTrait + PvTActionHolder classTrait',
	#instVars : [
		'#dirty => ObservableSlot',
		'#updating',
		'#editorPresenter',
		'#headerPresenter',
		'#footerPresenter'
	],
	#classVars : [
		'#ShowLineNumbers'
	],
	#category : 'Perspective-View-Editor',
	#package : 'Perspective',
	#tag : 'View-Editor'
}

{ #category : 'accessing - actions' }
PvEditorView class >> defineActionsExtraOn: actionGroup [
	<perspectiveActions>

	actionGroup registerGroup: #extra with: {
		PvToggleLineNumbersAction new.
	} 
]

{ #category : 'testing' }
PvEditorView class >> isShowingLineNumbers [

	^ ShowLineNumbers ifNil: [ ShowLineNumbers := true ]
]

{ #category : 'accessing' }
PvEditorView class >> showLineNumbers: aBoolean [

	ShowLineNumbers := aBoolean
]

{ #category : 'accessing' }
PvEditorView class >> type [

	^ self subclassResponsibility
]

{ #category : 'private - building' }
PvEditorView >> buildAdapterWithLayout: aSpecLayout [
	"This is needed because the process of building (and setting initial state) of a 
	 text/code presenter fires the event #whenTextChangedDo: and this will mark the editor 
	 as dirty when it is not, since this is original state."

	^ self updatingWhile: [ 
		super buildAdapterWithLayout: aSpecLayout ]
]

{ #category : 'accessing' }
PvEditorView >> content: aString [ 
	
	self updatingWhile: [ 
		editorPresenter text: aString ]
]

{ #category : 'accessing' }
PvEditorView >> defaultKeyboardFocus [

	^ editorPresenter
]

{ #category : 'layout' }
PvEditorView >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: headerPresenter expand: false; 
		add: editorPresenter;
		add: footerPresenter expand: false;
		yourself
]

{ #category : 'private' }
PvEditorView >> dirty: aBoolean [

	dirty := aBoolean
]

{ #category : 'private - actions' }
PvEditorView >> doReset [
	
	self updatePresenter.
	self resetDirty
]

{ #category : 'private - actions' }
PvEditorView >> doSubmit: aString [

	self subclassResponsibility
]

{ #category : 'private' }
PvEditorView >> editorContextMenuActions [

	^ CmCommandGroup forSpec
		beRoot;
		register: (editorPresenter rootCommandsGroup name: 'Code');
		"in: [ :this | self addMenuEditionCommandsTo: this presenter: editorPresenter ];"
		in: [ :this | self actions entries do: [ :each | this register: each ] ];
		"register: ((CmCommandGroup named: 'Playground') asSpecGroup
			register: ((CmCommandGroup named: 'Base options') asSpecGroup
				beDisplayedAsGroup;
				in: [ :this | self addToolbarCommandsTo: this ];
				yourself);
			register: ((CmCommandGroup named: 'Miscelaneous options') asSpecGroup
				beDisplayedAsGroup;
				register: (StShowLineNumbersCommand forSpecContext: self);
				yourself);
			yourself);"
		yourself
]

{ #category : 'private' }
PvEditorView >> editorFooterClass [

	^ PvEditorFooterPresenter
]

{ #category : 'private' }
PvEditorView >> editorHeaderClass [

	^ PvEditorHeaderPresenter
]

{ #category : 'private' }
PvEditorView >> editorIcon [
	| icon |
	
	icon := self model windowIconComposite.
	self isDirty ifTrue: [ icon addDirty ].
	^ icon buildOn: self application
]

{ #category : 'initialization' }
PvEditorView >> initialize [

	super initialize.
	self whenDirtyChangedDo: [ self updateHeader ]
]

{ #category : 'initialization' }
PvEditorView >> initializeEditor [
	
	(editorPresenter := self newCode)
		addStyle: 'stCode';
		addStyle: 'pvEditor';
		addScrollBarStyle: 'pvEditorScrollBar';
		overridingContextMenu;
		withEditionContextMenu;
		actions: self editorContextMenuActions;
		whenTextChangedDo: [ :newText :oldText | self textChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSubmit: aString ];
		whenResetDo: [ self doReset ];
		lineNumbers: self isShowingLineNumbers
]

{ #category : 'initialization' }
PvEditorView >> initializeEditorHeader [
	
	headerPresenter := self 
		instantiate: self editorHeaderClass 
		on: self model
]

{ #category : 'initialization' }
PvEditorView >> initializeFooter [

	footerPresenter := self 
		instantiate: self editorFooterClass 
		on: self model
]

{ #category : 'initialization' }
PvEditorView >> initializePresenters [

	self initializeEditorHeader.
	self initializeEditor.
	self initializeFooter.
	
	self addStyle: 'pvEditor'
]

{ #category : 'initialization' }
PvEditorView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self title	
]

{ #category : 'testing' }
PvEditorView >> isClassDefinitionEditor [

	^ false
]

{ #category : 'testing' }
PvEditorView >> isClassEditor [

	^ false
]

{ #category : 'testing' }
PvEditorView >> isCloseable [
	
	^ true
]

{ #category : 'testing' }
PvEditorView >> isCommentEditor [

	^ false
]

{ #category : 'testing' }
PvEditorView >> isDirty [

	^ dirty ifNil: [ dirty := false ]
]

{ #category : 'testing' }
PvEditorView >> isEditor [

	^ true
]

{ #category : 'testing' }
PvEditorView >> isSameAs: anObject [

	^ self species = anObject species
]

{ #category : 'testing' }
PvEditorView >> isShowingLineNumbers [

	^ self class isShowingLineNumbers
]

{ #category : 'private - testing' }
PvEditorView >> isUpdating [

	^ updating ifNil: [ updating := false ]
]

{ #category : 'accessing' }
PvEditorView >> markDirty [

	self isUpdating ifTrue: [ ^ self ].
	self isDirty ifTrue: [ ^ self ].
	self dirty: true
]

{ #category : 'accessing - model' }
PvEditorView >> model: aModel [

	model := aModel.
	headerPresenter model: aModel.
	self updatePresenter
]

{ #category : 'accessing' }
PvEditorView >> pageTitle [
	
	^ self isDirty 
		ifTrue: [ '*', (self model pageTitle) ]
		ifFalse: [ self model pageTitle ]
]

{ #category : 'accessing' }
PvEditorView >> replaceWith: aSimilarEditor [

	self updatingWhile: [ 
		self model: aSimilarEditor model ].
	"An editor should not be replaced when is dirty, but in case that happens I need to 
	 start over with a clean state."
	self resetDirty
]

{ #category : 'actions' }
PvEditorView >> reset [

	editorPresenter triggerResetAction
]

{ #category : 'accessing' }
PvEditorView >> resetDirty [

	self isDirty ifFalse: [ ^ self ].
	self dirty: false
]

{ #category : 'accessing' }
PvEditorView >> showLineNumbers: aBoolean [

	self class showLineNumbers: aBoolean.
	editorPresenter lineNumbers: aBoolean.
	self updateFooter
]

{ #category : 'accessing' }
PvEditorView >> spotterTitle [

	^ self model spotterTitle
]

{ #category : 'actions' }
PvEditorView >> submit [

	editorPresenter triggerSubmitAction
]

{ #category : 'accessing' }
PvEditorView >> tabLabel [

	^ self model shortName
]

{ #category : 'private' }
PvEditorView >> textChangedFrom: oldText to: newText [

	oldText = newText ifTrue: [ ^ self ].
	self markDirty
]

{ #category : 'initialization' }
PvEditorView >> title [

	self subclassResponsibility
	
]

{ #category : 'accessing' }
PvEditorView >> type [

	^ self class type
]

{ #category : 'emulating' }
PvEditorView >> typeByChar: aString [
	"for test purposes"
	
	editorPresenter typeByChar: aString
	
]

{ #category : 'initialization' }
PvEditorView >> updateFooter [

	footerPresenter actions: (self actions actionsForAll: #(extra))
]

{ #category : 'initialization' }
PvEditorView >> updateHeader [

	self withTileWindowDo: [ :w |
		w title: self model shortName.
		w windowIcon: self editorIcon ]
]

{ #category : 'initialization' }
PvEditorView >> updatePresenter [

	self updateHeader.
	self updateFooter
]

{ #category : 'private' }
PvEditorView >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : 'events' }
PvEditorView >> whenDirtyChangedDo: aBlock [

	self property: #dirty whenChangedDo: aBlock
]

{ #category : 'accessing' }
PvEditorView >> windowTitle [
	
	^ self isDirty 
		ifTrue: [ '*', (self model windowTitle) ]
		ifFalse: [ self model windowTitle ]
]
