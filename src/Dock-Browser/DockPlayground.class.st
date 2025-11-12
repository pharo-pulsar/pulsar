Class {
	#name : 'DockPlayground',
	#superclass : 'DockBaseView',
	#traits : 'DockTSnapshot',
	#classTraits : 'DockTSnapshot classTrait',
	#instVars : [
		'codePresenter',
		'toolbarPresenter',
		'page',
		'actionsPresenter',
		'moreActionsPresenter'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'defaults' }
DockPlayground class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea bottom;
		yourself
]

{ #category : 'defaults' }
DockPlayground class >> defaultTitle [

	^ 'Playground'
]

{ #category : 'accessing - actions' }
DockPlayground class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder 
		registerGroup: #actions with: {
			SpAction new
				priority: 1;
				name: 'New playground';
				description: 'Create a new playground';
				iconName: 'add';
				action: [ :aContext | aContext doNewPlayground ].		
			SpAction new
				priority: 2;
				name: 'Load page';
				description: 'Load a playground page';
				iconName: 'load';
				action: [ :aContext | aContext doLoadPage ].	
			SpAction new
				priority: 3;
				name: 'Versions';
				description: 'Browse versions of current playground page';
				iconName: 'versions';
				action: [ :aContext :aCommand | aContext doBrowseVersionsCommand: aCommand ].
			SpAction new
				priority: 4;
				name: 'Variables';
				description: 'Browse variables (bindings) defined in current playground';
				iconName: 'variables';
				action: [ :aContext :aCommand | aContext doBrowseBindingsCommand: aCommand ].
		}
]

{ #category : 'private - actions' }
DockPlayground >> activatePage: page [

	self model loadPage: page.
	self updatePresenter.
	self takeKeyboardFocus
]

{ #category : 'private - accessing' }
DockPlayground >> codePresenter [

	^ codePresenter
]

{ #category : 'initialization' }
DockPlayground >> connectPresenters [

	codePresenter whenTextChangedDo: [ :aString | self updatePageContent: aString ]
]

{ #category : 'accessing' }
DockPlayground >> contents [

	^ self model contents
]

{ #category : 'accessing' }
DockPlayground >> contents: aString [

	self model contents: aString.
	self updatePresenter
]

{ #category : 'layout' }
DockPlayground >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: codePresenter;
		yourself
]

{ #category : 'private - actions' }
DockPlayground >> doBrowseBindingsCommand: anAction [
	| bindingsPresenter |
	
	bindingsPresenter := self 
		instantiate: DockPlaygroundBindingsPresenter 
		on: codePresenter interactionModel.
		
	bindingsPresenter asPopover
		relativeTo: anAction presenter;
		popup
]

{ #category : 'private - actions' }
DockPlayground >> doBrowseVersionsCommand: anAction [
	| popover versionsPresenter |

	popover := self newPopover.

	versionsPresenter := self
		instantiate: DockPlaygroundVersionsBrowser 
		on: self model newVersionsModel.
	versionsPresenter registerToDock: self window.
	versionsPresenter whenActivatedDo: [ :anEntry | 
		codePresenter text: anEntry content ].

	popover := self newPopover
		presenter: versionsPresenter;
		relativeTo: anAction presenter;
		bePositionTop;
		popupModal
]

{ #category : 'private - actions' }
DockPlayground >> doClose [
	self withNearWindowLikeDo: [ :aWindow | aWindow close ] 
]

{ #category : 'private - actions' }
DockPlayground >> doLoadPage [

	(self instantiate: StPlaygroundPagesPresenter) 
		onLoadPage: [ :page | self activatePage: page ];
		openModalWithParent: self nearWindow
]

{ #category : 'private - actions' }
DockPlayground >> doNewPage [

	self activatePage: StPlaygroundPage new
]

{ #category : 'private - actions' }
DockPlayground >> doNewPlayground [

	self notificationCenter announce: DockRequestNewPlayground
]

{ #category : 'initialization' }
DockPlayground >> ensureCodeBindings [

	(codePresenter interactionModel bindings keys
		anySatisfy: [ :each | each = #thisBrowser ])
		ifTrue: [ ^ self ].
		
	codePresenter interactionModel 
		addBinding: (WorkspaceVariable key: #thisBrowser value: self window)
]

{ #category : 'events' }
DockPlayground >> eventSyntaxHighlightThemeChanged: ann [

	codePresenter syntaxHighlightTheme: self application syntaxHighlightTheme
]

{ #category : 'events' }
DockPlayground >> eventThemeChanged: ann [

	codePresenter styleScheme: self application styleScheme
]

{ #category : 'initialization' }
DockPlayground >> initialize [

	model := DockPlaygroundModel new.
	super initialize.
	self registerToSystemEvents
]

{ #category : 'initialization' }
DockPlayground >> initializePresenters [

	actionsPresenter := self newToolbar
		displayMode: self application toolbarDisplayMode;
		fillWith: (self actions actionsFor: #actions).
	
	moreActionsPresenter := self newButton
		addStyle: 'flat';
		icon: (self iconNamed: 'close');
		action: [ self doClose ];
		yourself.

	toolbarPresenter := self instantiate: DockEditorToolbarPresenter.
	toolbarPresenter 
		addPresenter: actionsPresenter;
		addPresenter: moreActionsPresenter.

	(codePresenter := self newCode)
		addStyle: 'stCode';
		interactionModel: self newInteractionModel; 
		systemNavigation: self newSystemNavigation
]

{ #category : 'initialization' }
DockPlayground >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: 'workspace')
]

{ #category : 'accessing' }
DockPlayground >> insertPopover: aPresenter [

	codePresenter insertPopoverAfterCurrentSelection: aPresenter
]

{ #category : 'private' }
DockPlayground >> newInteractionModel [

	^ StPlaygroundInteractionModel new
]

{ #category : 'private' }
DockPlayground >> newSystemNavigation [

	^ self systemNavigation
		responderPresenter: codePresenter;
		yourself
]

{ #category : 'accessing - snapshot' }
DockPlayground >> postRestoreSnapshot: aSnapshot [

	self ensureCodeBindings
]

{ #category : 'initialization' }
DockPlayground >> registerToSystemEvents [

	self announcer
		when: DockThemeChanged send: #eventThemeChanged: to: self;
		when: DockSyntaxHighlightThemeChanged send: #eventSyntaxHighlightThemeChanged: to: self
]

{ #category : 'accessing - snapshot' }
DockPlayground >> snapshot [

	^ DockPlaygroundSnapshot on: self
]

{ #category : 'accessing' }
DockPlayground >> systemNavigation [ 

	self withWindowDo: [ :aWindow | 
		^ aWindow systemNavigation ].
	^ super systemNavigation
]

{ #category : 'private - updating' }
DockPlayground >> updatePageContent: aString [

	self model contents: aString
]

{ #category : 'initialization' }
DockPlayground >> updatePresenter [ 

	super updatePresenter. 
	
	self updateTitle.
	
	self ensureCodeBindings.
	codePresenter text: self model contents
]

{ #category : 'initialization' }
DockPlayground >> updateTitle [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		aBreadcrumb addSegment: 'Playground' ]
]
