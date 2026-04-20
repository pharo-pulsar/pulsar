Class {
	#name : 'PulsarPlayground',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTSnapshot',
	#classTraits : 'PulsarTSnapshot classTrait',
	#instVars : [
		'codePresenter',
		'toolbarPresenter',
		'page',
		'actionsPresenter',
		'moreActionsPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'defaults' }
PulsarPlayground class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
]

{ #category : 'defaults' }
PulsarPlayground class >> defaultTitle [

	^ 'Playground'
]

{ #category : 'private - actions' }
PulsarPlayground >> activatePage: page [

	self model loadPage: page.
	self updatePresenter.
	self takeKeyboardFocus
]

{ #category : 'private - accessing' }
PulsarPlayground >> codePresenter [

	^ codePresenter
]

{ #category : 'initialization' }
PulsarPlayground >> connectPresenters [

	codePresenter whenTextChangedDo: [ :aString | self updatePageContent: aString ]
]

{ #category : 'accessing' }
PulsarPlayground >> contents [

	^ self model contents
]

{ #category : 'accessing' }
PulsarPlayground >> contents: aString [

	self model contents: aString.
	self updatePresenter
]

{ #category : 'layout' }
PulsarPlayground >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: codePresenter;
		yourself
]

{ #category : 'private - definitions' }
PulsarPlayground >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #actions with: [ :group | group 
		addActionWith: [ :action | action
			priority: 1;
			name: 'New playground';
			description: 'Create a new playground';
			iconName: 'add';
			action: [ self doNewPlayground ] ];
		addActionWith: [ :action | action
			priority: 2;
			name: 'Load page';
			description: 'Load a playground page';
			iconName: 'load';
			action: [ self doLoadPage ] ];	
		addActionWith: [ :action | action
			priority: 3;
			name: 'Versions';
			description: 'Browse versions of current playground page';
			iconName: 'versions';
			action: [ self doBrowseVersionsCommand: action ] ];
		addActionWith: [ :action | action
			priority: 4;
			name: 'Variables';
			description: 'Browse variables (bindings) defined in current playground';
			iconName: 'variables';
			action: [ self doBrowseBindingsCommand: action ] ] ]
]

{ #category : 'private - actions' }
PulsarPlayground >> doBrowseBindingsCommand: anAction [
	| bindingsPresenter |
	
	bindingsPresenter := self 
		instantiate: PulsarPlaygroundBindingsPresenter 
		on: codePresenter interactionModel.
		
	bindingsPresenter asPopover
		relativeTo: anAction presenter;
		popupModal
]

{ #category : 'private - actions' }
PulsarPlayground >> doBrowseVersionsCommand: anAction [
	| popover versionsPresenter |

	popover := self newPopover.

	versionsPresenter := self
		instantiate: PulsarPlaygroundVersionsBrowser 
		on: self model newVersionsModel.
	versionsPresenter registerToBrowser: self window.
	versionsPresenter whenActivatedDo: [ :anEntry | 
		codePresenter text: anEntry content ].

	popover := self newPopover
		presenter: versionsPresenter;
		relativeTo: anAction presenter;
		bePositionTop;
		popupModal
]

{ #category : 'private - actions' }
PulsarPlayground >> doClose [
	
	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - actions' }
PulsarPlayground >> doLoadPage [

	(self instantiate: StPlaygroundPagesPresenter) 
		onLoadPage: [ :page | self activatePage: page ];
		openModalWithParent: self nearWindow
]

{ #category : 'private - actions' }
PulsarPlayground >> doNewPage [

	self activatePage: StPlaygroundPage new
]

{ #category : 'private - actions' }
PulsarPlayground >> doNewPlayground [

	self notificationCenter announce: PulsarRequestNewPlayground
]

{ #category : 'initialization' }
PulsarPlayground >> ensureCodeBindings [

]

{ #category : 'events' }
PulsarPlayground >> eventSyntaxHighlightThemeChanged: ann [

	codePresenter syntaxHighlightTheme: self application syntaxHighlightTheme
]

{ #category : 'events' }
PulsarPlayground >> eventThemeChanged: ann [

	codePresenter styleScheme: self application styleScheme
]

{ #category : 'initialization' }
PulsarPlayground >> initialize [

	model := PulsarPlaygroundModel new.
	super initialize
]

{ #category : 'initialization' }
PulsarPlayground >> initializePresenters [

	self addStyle: 'pulsarPlayground'.

	actionsPresenter := self newToolbar
		displayMode: self application toolbarDisplayMode;
		fillWith: (self actions actionsFor: #actions).
	
	moreActionsPresenter := self newToolbar 
		beIcons;
		add: (self newButton
			addStyle: 'flat';
			icon: (self iconNamed: 'close');
			help: 'Close playground';
			action: [ self doClose ];
			yourself);
		yourself.

	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter 
		addPresenter: actionsPresenter;
		addPresenter: moreActionsPresenter.

	(codePresenter := self newCode)
		addStyle: 'stCode';
		interactionModel: self newInteractionModel; 
		systemNavigation: self newSystemNavigation
]

{ #category : 'initialization' }
PulsarPlayground >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: self panelPlacedIconName)
]

{ #category : 'accessing' }
PulsarPlayground >> insertPopover: aPresenter [

	codePresenter insertPopoverAfterCurrentSelection: aPresenter
]

{ #category : 'private' }
PulsarPlayground >> newInteractionModel [

	^ PulsarPlaygroundInteractionModel new
]

{ #category : 'private' }
PulsarPlayground >> newSystemNavigation [

	^ self systemNavigation
		responderPresenter: codePresenter;
		yourself
]

{ #category : 'private' }
PulsarPlayground >> panelPlacedIconName [

	^ 'workspace'
]

{ #category : 'accessing - snapshot' }
PulsarPlayground >> postRestoreSnapshot: aSnapshot [
]

{ #category : 'initialization' }
PulsarPlayground >> registerToSystemEvents [

	self announcer
		when: PulsarThemeChanged send: #eventThemeChanged: to: self;
		when: PulsarSyntaxHighlightThemeChanged send: #eventSyntaxHighlightThemeChanged: to: self
]

{ #category : 'accessing - snapshot' }
PulsarPlayground >> snapshot [

	^ PulsarPlaygroundSnapshot on: self
]

{ #category : 'accessing' }
PulsarPlayground >> systemNavigation [ 

	self withWindowDo: [ :aWindow | 
		^ aWindow systemNavigation ].
	^ super systemNavigation
]

{ #category : 'private - updating' }
PulsarPlayground >> updatePageContent: aString [

	self model contents: aString
]

{ #category : 'initialization' }
PulsarPlayground >> updatePresenter [ 

	super updatePresenter. 
	
	self updateTitle.
	
	codePresenter text: self model contents
]

{ #category : 'initialization' }
PulsarPlayground >> updateTitle [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		aBreadcrumb addSegment: 'Playground' ]
]
