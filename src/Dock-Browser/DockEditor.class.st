Class {
	#name : 'DockEditor',
	#superclass : 'DockBaseView',
	#instVars : [
		'updating',
		'editorPresenter'
	],
	#category : 'Dock-Browser-Core',
	#package : 'Dock-Browser',
	#tag : 'Core'
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
	aWindowPresenter title: self model name.
	aWindowPresenter whenPresentedDo: [
		self triggerEditorActivated ]
]

{ #category : 'private - updating' }
DockEditor >> isUpdating [

	^ updating
]

{ #category : 'private - updating' }
DockEditor >> markDirty [

	self withDockableWindowDo: [ :w | w modified: true ]
]

{ #category : 'private - updating' }
DockEditor >> textChangedFrom: oldText to: newText [

	self isUpdating ifTrue: [ ^ self ].
	oldText = newText ifTrue: [ ^ self ].
	
	self markDirty
]

{ #category : 'private - announcing' }
DockEditor >> triggerEditorActivated [

	self notificationCenter announce: (DockEditorActivated newValue: self)
]

{ #category : 'private - updating' }
DockEditor >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]
