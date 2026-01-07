"
This is a base editor from which all things editable should inherit.
It defines a common behavior between the different buffers that can be edited by the user.

Its default position in the dock browser is center.
"
Class {
	#name : 'PulsarEditor',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTPanelWindow',
	#classTraits : 'PulsarTPanelWindow classTrait',
	#instVars : [
		'updating',
		'toolbarPresenter',
		'editorPresenter',
		'dirty',
		'editorOverlayLayout',
		'dirtyMarkerPresenter',
		'searchBarPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing - actions' }
PulsarEditor class >> defineNavigationActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #navigation with: [ :group | group 
		priority: 100;
		name: 'Navigation';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action 
			name: 'Show hierarchy';
			description: 'Show hierarchy';
			iconName: #hierarchy; "was #smallHierarchyBrowser... TODO see semantic meaning"
			shortcutKey: $h mod1; 
			action: [ :aContext | aContext doShowHierarchy: action ] ];
		addActionWith: [ :action | action 
			name: 'Show senders';
			description: 'Show senders';
			iconName: #senders;
			action: [ :aContext | aContext doBrowseSendersCommand: action ] ] ]
]

{ #category : 'accessing - actions' }
PulsarEditor class >> defineWindowActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #extraWindow with: [ :group | group
		priority: 1010;
		name: 'Window';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			name: 'Maximize';
			description: 'Maximize current window';
			action: [ :aContext | aContext withPanelWindowDo: #maximize ] ];		
		addActionWith: [ :action | action
			name: 'Detach as Window';
			shortcutKey: Character arrowUp alt shift;
			description: 'Detach this window from the Pulsar (open a new window)';
			action: [ :aContext | aContext doDetachWindow ] ] ]
]

{ #category : 'accessing - overlay' }
PulsarEditor >> addOverlay: aPresenter [

	self editorOverlayLayout addOverlay: aPresenter
]

{ #category : 'accessing - overlay' }
PulsarEditor >> addOverlay: aPresenter withConstraints: aBlock [

	self editorOverlayLayout 
		addOverlay: aPresenter 
		withConstraints: aBlock
]

{ #category : 'private - actions' }
PulsarEditor >> close [

	self withNearWindowLikeDo: #close
]

{ #category : 'private' }
PulsarEditor >> collectContentActions [

	^ self model actionDecorators
]

{ #category : 'initialization' }
PulsarEditor >> connectPresenters [

	"self eventHandler whenFocusReceivedDo: [ :event | 
		self focusReceived ]."

	editorPresenter
		whenTextChangedDo: [ :newText :oldText | self textChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSubmit: aString ];
		whenResetDo: [ self doReset ]
]

{ #category : 'api - focus' }
PulsarEditor >> defaultKeyboardFocus [

	^ editorPresenter
]

{ #category : 'layout' }
PulsarEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: (self editorOverlayLayout
			child: editorPresenter;
			yourself);
		add: searchBarPresenter expand: false;
		yourself
]

{ #category : 'private' }
PulsarEditor >> dirtyMarkerPresenter [

	^ dirtyMarkerPresenter ifNil: [
		dirtyMarkerPresenter := self newDirtyMarkerPresenter ] 
]

{ #category : 'private - actions' }
PulsarEditor >> doBrowseSendersCommand: anAction [
	
	self subclassResponsibility
]

{ #category : 'private - actions' }
PulsarEditor >> doReset [

	self updatingWhile: [ 
		editorPresenter text: self originalContent.
		self unmarkDirty ]
]

{ #category : 'private - actions' }
PulsarEditor >> doRunTestCommand: anAction [

	self model runTestAnnouncingTo: self notificationCenter
]

{ #category : 'private - actions' }
PulsarEditor >> doShowHierarchy [

	self subclassResponsibility
]

{ #category : 'private - actions' }
PulsarEditor >> doShowHierarchy: anAction [
	| popover navigation |
	
	popover := self newPopover.
	navigation := self 
		instantiate: PulsarHierarchyPresenter 
		on: (PulsarHierarchyModel on: self model). 
	
	navigation notificationCenter: self notificationCenter.
	
	popover
		presenter: navigation;
		relativeTo: anAction presenter;
		popupModal
]

{ #category : 'private - actions' }
PulsarEditor >> doSubmit: aString [
	"process the save of the edited content.
	 updates the model (which in time will trigger changes in the system). 
	 We need to inform the UI something has changed to allow him to react"
	| result oldModel |
	
	oldModel := self model copy.
	result := self updateModel: aString.
	result ifTrue: [
		self unmarkDirty.
		self notificationCenter announce: (PulsarModelChanged 
			newValue: self model
			oldEntity: oldModel) ].

	^ result
]

{ #category : 'initialization' }
PulsarEditor >> editorActions [
		
	^ self actions actionsForAll: #(navigation extraWindow)
]

{ #category : 'private - actions' }
PulsarEditor >> editorContextMenuActions [

	^ SpActionGroup new 
		add: (editorPresenter rootCommandsGroup name: 'Code');
		add: self editorActions beDisplayedAsGroup;
		yourself
]

{ #category : 'private - overlay' }
PulsarEditor >> editorOverlayLayout [

	^  editorOverlayLayout ifNil: [ editorOverlayLayout := SpOverlayLayout new ]
]

{ #category : 'private' }
PulsarEditor >> editorPresenter [

	^ editorPresenter
]

{ #category : 'initialization' }
PulsarEditor >> editorToolbarActions [
		
	^ self actions actionsFor: #navigation
]

{ #category : 'events' }
PulsarEditor >> eventModelChanged: ann [
	
	ann value = self model ifFalse: [ ^ self ].
	
	self updateTitle.
	self updateBreadcrumbs
]

{ #category : 'events' }
PulsarEditor >> eventModelRemoved: anAnnouncement [

	self subclassResponsibility
]

{ #category : 'events' }
PulsarEditor >> eventSyntaxHighlightThemeChanged: ann [

	editorPresenter syntaxHighlightTheme: self application syntaxHighlightTheme
]

{ #category : 'events' }
PulsarEditor >> eventTestCaseEnded: aTestCaseEnded [

	self subclassResponsibility
]

{ #category : 'events' }
PulsarEditor >> eventThemeChanged: ann [

	editorPresenter styleScheme: self application styleScheme
]

{ #category : 'private - actions' }
PulsarEditor >> forceClose [

	self withPanelWindowDo: [ :aWindow | aWindow forceClose ].
	
	self close
]

{ #category : 'initialization' }
PulsarEditor >> initialize [

	super initialize.
	self registerToSystemEvents.
	dirty := false. 
	updating := false
]

{ #category : 'initialization' }
PulsarEditor >> initializePanelWindow: aWindowPresenter [

	super initializePanelWindow: aWindowPresenter.
	aWindowPresenter
		actions: self windowActions;
		whenPresentedDo: [ self panelPresented ];
		whenPlacedDo: [ "self panelPlaced" ];
		whenFocusReceivedDo: [ self panelFocused ];
		whenSaveDo: [ :ann | ann success: self saveContent ];
		whenDiscardDo: [ :ann | 
			"I don't know what to do with this... nothing feels right." ]
]

{ #category : 'initialization' }
PulsarEditor >> initializePresenters [

	self addStyle: 'dockEditor'.

	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter actions: self editorToolbarActions.

	(editorPresenter := self newCode)
		addStyle: 'stCode';
		addScrollBarStyle: 'stCodeScrollBar';
		overridingContextMenu;
		withEditionContextMenu;
		actions: self editorContextMenuActions;
		lineNumbers: self application isShowingLineNumbers;
		systemNavigation: (self systemNavigation
			responderPresenter: editorPresenter;
			yourself).
			
	searchBarPresenter := self instantiate: PulsarSearchBarPresenter on: editorPresenter
]

{ #category : 'initialization' }
PulsarEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model ifNotNil: #name);
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'testing' }
PulsarEditor >> isDirty [

	^ dirty
]

{ #category : 'testing' }
PulsarEditor >> isEditor [
	
	^ true
]

{ #category : 'private - updating' }
PulsarEditor >> isUpdating [

	^ updating
]

{ #category : 'private - updating' }
PulsarEditor >> markDirty [
	
	dirty ifTrue: [ ^ self ].
	dirty := true.
	self withPanelWindowDo: [ :w | w modified: true ].
	self 
		addOverlay: self dirtyMarkerPresenter 
		withConstraints: [ :c | c hAlignEnd; vAlignStart ]
]

{ #category : 'private' }
PulsarEditor >> newDirtyMarkerPresenter [

	^ self newToolbar
		addStyle: 'dockDirtyMarker';
		beIcons;
		add: (self newToolbarButton
			addStyle: 'accept';
			icon: (self iconNamed: #accept);
			action: [ self doSubmit: editorPresenter text ];
			help: 'Accept changes';
			yourself);
		add: (self newToolbarButton
			addStyle: 'cancel';
			icon: (self iconNamed: #cancel);
			action: [ self doReset ];
			help: 'Cancel changes';
			yourself);
		yourself
]

{ #category : 'private - announcing' }
PulsarEditor >> notifyEditorActivated [

	self notificationCenter announce: (PulsarEditorActivated newValue: self)
]

{ #category : 'private - announcing' }
PulsarEditor >> notifyEntityChanged: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (PulsarModelChanged newValue: anEntity)
]

{ #category : 'private' }
PulsarEditor >> originalContent [
	"used to compare when deciding if an editor is dirty or not"

	^ self subclassResponsibility
]

{ #category : 'private' }
PulsarEditor >> panelFocused [

	logger trace.
	self notifyEditorActivated
]

{ #category : 'private' }
PulsarEditor >> panelPlaced [

	logger trace.
	"right now nothing"
]

{ #category : 'private' }
PulsarEditor >> panelPresented [

	logger trace.
	self recordLastPresented.
	self panelFocused
]

{ #category : 'initialization' }
PulsarEditor >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarModelChanged send: #eventModelChanged: to: self;
		when: PulsarModelRemoved send: #eventModelRemoved: to: self
]

{ #category : 'initialization' }
PulsarEditor >> registerToSystemEvents [
	"subclasses can fill this"
	
	self announcer
		when: PulsarThemeChanged send: #eventThemeChanged: to: self;
		when: PulsarSyntaxHighlightThemeChanged send: #eventSyntaxHighlightThemeChanged: to: self;
		when: TestCaseEnded send: #eventTestCaseEnded: to: self;
		when: SpWindowWillClose send: #windowWillClose: to: self
]

{ #category : 'accessing - overlay' }
PulsarEditor >> removeOverlay: aPresenter [

	self editorOverlayLayout removeOverlay: aPresenter
]

{ #category : 'private - actions' }
PulsarEditor >> saveContent [
	"save contents and answer a boolean if it is saved (usually after the user attempting 
	 to close the editor with modifications inside), since this is used to validate the 
	 close, it needs to return a boolean indicating it can be done or not."
	
	^ self doSubmit: editorPresenter text
]

{ #category : 'accessing - snapshot' }
PulsarEditor >> snapshot [

	^ PulsarEditorSnapshot on: self
]

{ #category : 'accessing' }
PulsarEditor >> spotterTitle [

	       ^ self model name
]

{ #category : 'accessing' }
PulsarEditor >> systemNavigation [ 

	self withWindowDo: [ :window | ^ window systemNavigation ].
	
	^ super systemNavigation
]

{ #category : 'private - updating' }
PulsarEditor >> textChangedFrom: oldText to: newText [

	self isUpdating ifTrue: [ ^ self ].
	
	oldText = newText ifTrue: [ ^ self ].
	(self isDirty 
		and: [ newText = self originalContent ])
		ifTrue: [ ^ self unmarkDirty ].
	
	self markDirty
]

{ #category : 'private' }
PulsarEditor >> toolbarPresenter [

	^ toolbarPresenter
]

{ #category : 'private - updating' }
PulsarEditor >> unmarkDirty [

	dirty ifFalse: [ ^ self ].
	dirty := false.
	self withPanelWindowDo: [ :w | w modified: false ].
	self removeOverlay: self dirtyMarkerPresenter
]

{ #category : 'initialization' }
PulsarEditor >> updateBreadcrumbs [

	"override this to update the breadcrumb header"
]

{ #category : 'initialization' }
PulsarEditor >> updateContentActions [
	| contentActions |

	contentActions := PulsarActionContextVisitor new
		context: self;
		visit: self collectContentActions.
		
	toolbarPresenter contentActions: contentActions
]

{ #category : 'private - actions' }
PulsarEditor >> updateModel: aString [

	^ self model 
		updateWith: aString
		notifying: editorPresenter interactionModel
]

{ #category : 'initialization' }
PulsarEditor >> updatePanelWindowTitle [
	self withPanelWindowDo: [ :w | 
		w title: self model name ]
]

{ #category : 'initialization' }
PulsarEditor >> updatePresenter [

	self updateTitle.
	self updateBreadcrumbs.
	self updateContentActions
]

{ #category : 'initialization' }
PulsarEditor >> updateSearch [
	"IMPORTANT: this update needs to happen *after* updating the editor 
	 (because it acts on the changed text of it)"
	
	searchBarPresenter isVisible 
		ifTrue: [ searchBarPresenter updatePresenter ]
]

{ #category : 'initialization' }
PulsarEditor >> updateTitle [

	self nearWindowLike ifNotNil: [ :aWindow |
		logger trace: aWindow.
		(PulsarEditorUpdateVisitor on: self) visit: aWindow ]
]

{ #category : 'private - updating' }
PulsarEditor >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : 'initialization' }
PulsarEditor >> windowActions [
		
	^ self actions actionsFor: #extraWindow
]

{ #category : 'accessing' }
PulsarEditor >> windowWillClose: ann [

	self isDirty ifFalse: [ ^ self ].
	
	ann denyClose
]
