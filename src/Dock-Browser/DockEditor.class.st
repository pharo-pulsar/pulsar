Class {
	#name : 'DockEditor',
	#superclass : 'DockBaseView',
	#instVars : [
		'updating',
		'toolbarPresenter',
		'editorPresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
DockEditor >> connectPresenters [

	editorPresenter
		whenTextChangedDo: [ :newText :oldText | self textChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSubmit: aString ];
		whenResetDo: [ self doReset ]
]

{ #category : 'api - focus' }
DockEditor >> defaultKeyboardFocus [

	^ editorPresenter
]

{ #category : 'layout' }
DockEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: editorPresenter;
		yourself
]

{ #category : 'private - actions' }
DockEditor >> doReset [

	self halt. "TODO"
]

{ #category : 'private - actions' }
DockEditor >> doSubmit: aString [
	"process the save of the edited content.
	 updates the model (which in time will trigger changes in the system). 
	 We need to inform the UI something has changed to allow him to react"
	| result oldModel |
	
	oldModel := self model copy.
	result := self model 
		updateWith: aString
		notifying: editorPresenter interactionModel.
	result ifTrue: [
		self unmarkDirty.
		self notificationCenter announce: (DockModelChanged 
			newValue: self model
			oldEntity: oldModel) ].

	^ result
]

{ #category : 'initialization' }
DockEditor >> editorActions [
		
	^ self actions actionsFor: #navigation

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

{ #category : 'private' }
DockEditor >> editorPresenter [

	^ editorPresenter
]

{ #category : 'events' }
DockEditor >> eventModelChanged: ann [
	
	ann value = self model ifFalse: [ ^ self ].
	
	self updateTitle.
	self updateBreadcrumbs
]

{ #category : 'events' }
DockEditor >> eventModelRemoved: anAnnouncement [

	self subclassResponsibility
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

	toolbarPresenter := self instantiate: DockEditorToolbarPresenter.
	toolbarPresenter actions: self editorActions.

	(editorPresenter := self newCode)
		addStyle: 'stCode';
		addStyle: 'dockEditor';
		addScrollBarStyle: 'dockEditorScrollBar';
		overridingContextMenu;
		withEditionContextMenu;
		actions: self editorContextMenuActions;
		lineNumbers: self application isShowingLineNumbers;
		systemNavigation: (self systemNavigation
			codePresenter: editorPresenter ;
			yourself)
]

{ #category : 'initialization' }
DockEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model name;
		whenClosedDo: [ self notifyEditorClosed  ]
]

{ #category : 'testing' }
DockEditor >> isDirty [

	self withPanelWindowDo: [ :aWindow | ^ aWindow isModified ].
	^ false
]

{ #category : 'testing' }
DockEditor >> isEditor [
	
	^ true
]

{ #category : 'private - updating' }
DockEditor >> isUpdating [

	^ updating
]

{ #category : 'private - updating' }
DockEditor >> markDirty [

	self withPanelWindowDo: [ :w | w modified: true ]
]

{ #category : 'initialization' }
DockEditor >> notifyEditorClosed [

	self notificationCenter announce: (DockEditorClosed newValue: self model)
]

{ #category : 'private' }
DockEditor >> originalContent [
	"used to compare when deciding if an editor is dirty or not"

	^ self subclassResponsibility
]

{ #category : 'initialization' }
DockEditor >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: DockModelChanged send: #eventModelChanged: to: self;
		when: DockModelRemoved send: #eventModelRemoved: to: self
]

{ #category : 'private - actions' }
DockEditor >> saveContent [
	"save contents and answer a boolean if it is saved (usually after the user attempting 
	 to close the editor with modifications inside), since this is used to validate the 
	 close, it needs to return a boolean indicating it can be done or not."
	
	^ self doSubmit: editorPresenter text
]

{ #category : 'accessing' }
DockEditor >> systemNavigation [ 

	self withWindowDo: [ :window | ^ window systemNavigation ].
	
	^ super systemNavigation
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

{ #category : 'private' }
DockEditor >> toolbarPresenter [

	^ toolbarPresenter
]

{ #category : 'private - announcing' }
DockEditor >> triggerEditorActivated [

	self notificationCenter announce: (DockEditorActivated newValue: self)
]

{ #category : 'private - updating' }
DockEditor >> unmarkDirty [

	self withPanelWindowDo: [ :w | w modified: false ]
]

{ #category : 'initialization' }
DockEditor >> updateBreadcrumbs [

	"override this to update the breadcrumb header"
]

{ #category : 'initialization' }
DockEditor >> updatePresenter [
	
	self nearWindowLike ifNotNil: [ :aWindow |
		(DockEditorUpdateVisitor on: self) visit: aWindow ].
		
	self updateBreadcrumbs
]

{ #category : 'initialization' }
DockEditor >> updateTitle [

	self withPanelWindowDo: [ :w | 
		w title: self model name ]
]

{ #category : 'private - updating' }
DockEditor >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]
