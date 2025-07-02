Class {
	#name : 'DockEditor',
	#superclass : 'DockBaseView',
	#traits : 'DockTPanelWindow',
	#classTraits : 'DockTPanelWindow classTrait',
	#instVars : [
		'updating',
		'toolbarPresenter',
		'editorPresenter',
		'dirty',
		'editorOverlayLayout',
		'dirtyMarkerPresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing - actions' }
DockEditor class >> defineNavigationActionGroup: actionGroup [
	<perspectiveActionGroup: #navigation>
	
	actionGroup 
		priority: 100;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
DockEditor class >> defineNavigationActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #navigation with: { 
		$h mod1 -> DockHierarchyNavigationCommand new
	}
]

{ #category : 'accessing - actions' }
DockEditor class >> defineWindowActionGroupOn: actionGroup [ 
	<perspectiveActionGroup: #extraWindow>

	actionGroup
		priority: 1010;
		name: 'Window';
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
DockEditor class >> defineWindowActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #extraWindow with: { 
		PvAction new
			name: 'Maximize';
			description: 'Maximize current window';
			action: [ :aContext | aContext withPanelWindowDo: #maximize ].		
		PvAction new
			name: 'Detach as Window';
			shortcut: Character arrowUp alt shift;
			description: 'Detach this window from the Dock (open a new window)';
			action: [ :aContext |  ].			
	}
]

{ #category : 'accessing - overlay' }
DockEditor >> addOverlay: aPresenter [

	self editorOverlayLayout addOverlay: aPresenter
]

{ #category : 'accessing - overlay' }
DockEditor >> addOverlay: aPresenter withConstraints: aBlock [

	self editorOverlayLayout addOverlay: aPresenter withConstraints: aBlock
]

{ #category : 'initialization' }
DockEditor >> connectPresenters [

	"self eventHandler whenFocusReceivedDo: [ :event | 
		self focusReceived ]."

	editorPresenter
		whenTextChangedDo: [ :newText :oldText | self textChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSubmit: aString ];
		whenResetDo: [ self doReset ].
]

{ #category : 'api - focus' }
DockEditor >> defaultKeyboardFocus [

	^ editorPresenter
]

{ #category : 'layout' }
DockEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: ((editorOverlayLayout := SpOverlayLayout new)
			child: editorPresenter;
			yourself);
		yourself
]

{ #category : 'private' }
DockEditor >> dirtyMarkerPresenter [

	^ dirtyMarkerPresenter ifNil: [
		dirtyMarkerPresenter := self newDirtyMarkerPresenter ] 
]

{ #category : 'private - actions' }
DockEditor >> doReset [

	self updatingWhile: [ 
		editorPresenter text: self originalContent.
		self unmarkDirty ]
]

{ #category : 'private - actions' }
DockEditor >> doRunTestCommand: anAction [
	| resultAnnouncement |
	
	resultAnnouncement := self model runTest.
	anAction presenter updatePresenter.
	self notificationCenter announce: resultAnnouncement
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
		
	^ self actions actionsForAll: #(navigation extraWindow)
]

{ #category : 'private - actions' }
DockEditor >> editorContextMenuActions [

	^ SpActionGroup new 
		add: (editorPresenter rootCommandsGroup name: 'Code');
		add: self editorActions beDisplayedAsGroup;
		yourself
]

{ #category : 'private - overlay' }
DockEditor >> editorOverlayLayout [

	^ editorOverlayLayout
]

{ #category : 'private' }
DockEditor >> editorPresenter [

	^ editorPresenter
]

{ #category : 'initialization' }
DockEditor >> editorToolbarActions [
		
	^ self actions actionsFor: #navigation
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
	dirty := false. 
	updating := false
]

{ #category : 'initialization' }
DockEditor >> initializePanelWindow: aWindowPresenter [

	super initializePanelWindow: aWindowPresenter.
	aWindowPresenter
		actions: self windowActions;
		whenPresentedDo: [ self panelPresented ];
		whenFocusReceivedDo: [ self panelFocused ];
		whenSaveDo: [ :ann | ann success: self saveContent ];
		whenDiscardDo: [ :ann | 
			"I don't know what to do with this... nothing feels right." ]
]

{ #category : 'initialization' }
DockEditor >> initializePresenters [

	toolbarPresenter := self instantiate: DockEditorToolbarPresenter.
	toolbarPresenter actions: self editorToolbarActions.

	(editorPresenter := self newCode)
		addStyle: 'stCode';
		addStyle: 'dockEditor';
		addScrollBarStyle: 'dockEditorScrollBar';
		overridingContextMenu;
		withEditionContextMenu;
		actions: self editorContextMenuActions;
		lineNumbers: self application isShowingLineNumbers;
		systemNavigation: (self systemNavigation
			responderPresenter: editorPresenter;
			yourself)
]

{ #category : 'initialization' }
DockEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model ifNotNil: #name);
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'testing' }
DockEditor >> isDirty [

	^ dirty
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
	
	dirty ifTrue: [ ^ self ].
	dirty := true.
	self withPanelWindowDo: [ :w | w modified: true ].
	self 
		addOverlay: self dirtyMarkerPresenter 
		withConstraints: [ :c | c hAlignEnd; vAlignStart ]
]

{ #category : 'private' }
DockEditor >> newDirtyMarkerPresenter [

	^ self newToolbar
		beIcons;
		add: (self newToolbarButton
			icon: (self iconNamed: #accept);
			action: [ self doSubmit: editorPresenter text ];
			help: 'Accept changes';
			yourself);
		add: (self newToolbarButton
			icon: (self iconNamed: #cancel);
			action: [ self doReset ];
			help: 'Cancel changes';
			yourself);
		yourself
]

{ #category : 'private - announcing' }
DockEditor >> notifyEditorActivated [

	self notificationCenter announce: (DockEditorActivated newValue: self)
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

{ #category : 'private' }
DockEditor >> panelFocused [

	logger trace.
	self notifyEditorActivated
]

{ #category : 'private' }
DockEditor >> panelPresented [

	logger trace.
	self recordLastPresented.
	self panelFocused
]

{ #category : 'initialization' }
DockEditor >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: DockModelChanged send: #eventModelChanged: to: self;
		when: DockModelRemoved send: #eventModelRemoved: to: self
]

{ #category : 'accessing - overlay' }
DockEditor >> removeOverlay: aPresenter [

	self editorOverlayLayout removeOverlay: aPresenter
]

{ #category : 'private - actions' }
DockEditor >> saveContent [
	"save contents and answer a boolean if it is saved (usually after the user attempting 
	 to close the editor with modifications inside), since this is used to validate the 
	 close, it needs to return a boolean indicating it can be done or not."
	
	^ self doSubmit: editorPresenter text
]

{ #category : 'accessing - snapshot' }
DockEditor >> snapshot [

	^ DockEditorSnapshot on: self
]

{ #category : 'accessing' }
DockEditor >> spotterTitle [

	       ^ self model name
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

{ #category : 'private - updating' }
DockEditor >> unmarkDirty [

	dirty ifFalse: [ ^ self ].
	dirty := false.
	self withPanelWindowDo: [ :w | w modified: false ].
	self removeOverlay: self dirtyMarkerPresenter
]

{ #category : 'initialization' }
DockEditor >> updateBreadcrumbs [

	"override this to update the breadcrumb header"
]

{ #category : 'initialization' }
DockEditor >> updateContentActions [
	self application defer: [ 
		self model resetActionDecorators.
		self model actionDecorators ifNotEmpty: [ :aCollection |  
			toolbarPresenter contentActions: (SpActionGroup new 
				addAll: (aCollection collect: [ :each | 
					each 
						context: self; 
						asSpecCommand ]);
				yourself) ] ]
]

{ #category : 'initialization' }
DockEditor >> updatePresenter [
	
	self nearWindowLike ifNotNil: [ :aWindow |
		(DockEditorUpdateVisitor on: self) visit: aWindow ].
		
	self updateBreadcrumbs.
	self updateContentActions
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

{ #category : 'initialization' }
DockEditor >> windowActions [
		
	^ self actions actionsFor: #extraWindow
]
