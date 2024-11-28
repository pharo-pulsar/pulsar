Class {
	#name : 'DockEditor',
	#superclass : 'DockBaseView',
	#instVars : [
		'updating',
		'editorPresenter'
	],
	#category : 'Dock-Browser-Editor',
	#package : 'Dock-Browser',
	#tag : 'Editor'
}

{ #category : 'initialization' }
DockEditor >> connectPresenters [

	editorPresenter
		whenTextChangedDo: [ :newText :oldText | self textChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSubmit: aString ];
		whenResetDo: [ self doReset ]
]

{ #category : 'layout' }
DockEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: editorPresenter;
		yourself
]

{ #category : 'private - actions' }
DockEditor >> doReset [
]

{ #category : 'private - actions' }
DockEditor >> doSubmit: aString [
	"process the save of the edited content.
	 updates the model (which in time will trigger changes in the system). 
	 We need to inform the UI something has changed to allow him to react"
	| result |
	
	result := self model 
		updateWith: aString
		notifying: editorPresenter interactionModel.
	result ifTrue: [
		self unmarkDirty.
		self notificationCenter announce: (DockModelChanged newValue: self model) ].
	^ result
]

{ #category : 'private - actions' }
DockEditor >> editorContextMenuActions [

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

{ #category : 'initialization' }
DockEditor >> initialize [

	super initialize.
	updating := false
]

{ #category : 'initialization' }
DockEditor >> initializePanelWindow: aWindowPresenter [

	super initializePanelWindow: aWindowPresenter.
	aWindowPresenter 
		whenFocusReceivedDo: [ self triggerEditorActivated ];
		whenSaveDo: [ :ann | ann success: self saveContent ];
		whenDiscardDo: [ :ann | 
			"I don't know what to do with this... nothing feels right." ]
]

{ #category : 'initialization' }
DockEditor >> initializePresenters [

	(editorPresenter := self newCode)
		addStyle: 'stCode';
		addStyle: 'dockEditor';
		addScrollBarStyle: 'dockEditorScrollBar';
		overridingContextMenu;
		withEditionContextMenu;
		actions: self editorContextMenuActions;
		lineNumbers: self application isShowingLineNumbers
]

{ #category : 'initialization' }
DockEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self model name
]

{ #category : 'testing' }
DockEditor >> isDirty [

	self withPanelWindowDo: [ :aWindow | ^ aWindow isModified ].
	^ false
]

{ #category : 'private - updating' }
DockEditor >> isUpdating [

	^ updating
]

{ #category : 'private - updating' }
DockEditor >> markDirty [

	self withPanelWindowDo: [ :w | w modified: true ]
]

{ #category : 'private' }
DockEditor >> originalContent [
	"used to compare when deciding if an editor is dirty or not"

	^ self subclassResponsibility
]

{ #category : 'private - actions' }
DockEditor >> saveContent [
	"save contents and answer a boolean if it is saved (usually after the user attempting 
	 to close the editor with modifications inside), since this is used to validate the 
	 close, it needs to return a boolean indicating it can be done or not."
	
	^ self doSubmit: editorPresenter text
]

{ #category : 'private - updating' }
DockEditor >> textChangedFrom: oldText to: newText [

	self isUpdating ifTrue: [ ^ self ].
	oldText = newText ifTrue: [ ^ self ].
	(self isDirty 
		and: [ newText = self originalContent ])
		ifTrue: [ ^ self unmarkDirty ].
	
	self markDirty
]

{ #category : 'private - announcing' }
DockEditor >> triggerEditorActivated [

	self notificationCenter announce: (DockEditorActivated newValue: self)
]

{ #category : 'private - updating' }
DockEditor >> unmarkDirty [

	self withPanelWindowDo: [ :w | w modified: false ]
]

{ #category : 'private - updating' }
DockEditor >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]
