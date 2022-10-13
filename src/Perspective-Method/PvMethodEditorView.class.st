Class {
	#name : #PvMethodEditorView,
	#superclass : #PvEditorView,
	#category : #'Perspective-Method-View'
}

{ #category : #'accessing - actions' }
PvMethodEditorView class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #navigation with: { 
		$h mod1 -> PvMethodHierarchyNavigationCommand new
	} 
]

{ #category : #accessing }
PvMethodEditorView class >> type [

	^ #method
]

{ #category : #initialization }
PvMethodEditorView >> connectPresenters [
	
	footerPresenter announcer 
		when: PvMethodEditorProtocolChanged 
		send: #updateProtocol:
		to: self
]

{ #category : #accessing }
PvMethodEditorView >> contextMenuActionGroups [

	^ #(navigation)
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
PvMethodEditorView >> editorFooterClass [

	^ PvMethodEditorFooterPresenter
]

{ #category : #private }
PvMethodEditorView >> editorHeaderClass [

	^ PvMethodEditorHeaderPresenter
]

{ #category : #initialization }
PvMethodEditorView >> initializePresenters [

	super initializePresenters.
	self addStyle: 'pvMethodEditor'
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

	^ (self instantiate: PvHeaderBarPresenter)
		toolbarActions: (self actions actionsForAll: #(action methodAction));
		yourself
]

{ #category : #initialization }
PvMethodEditorView >> updateHeader [

	super updateHeader.
	headerPresenter actions: (self actions actionsFor: #navigation)
]

{ #category : #initialization }
PvMethodEditorView >> updatePresenter [

	super updatePresenter.
	self updatingWhile: [
		editorPresenter
			beForMethod: self model entity;
			text: self model sourceCode ]
]

{ #category : #private }
PvMethodEditorView >> updateProtocol: ann [ 

	self model protocol: ann newProtocol.
	self updateFooter.
	self markDirty
]
