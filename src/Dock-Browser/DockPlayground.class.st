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
			PvAction new
				priority: 1;
				name: 'New playground';
				description: 'Create a new playground';
				iconCompositeName: 'add';
				action: [ :aContext | aContext doNewPlayground ].		
			PvAction new
				priority: 2;
				name: 'Load page';
				description: 'Load a playground page';
				iconCompositeName: 'load';
				action: [ :aContext | aContext doLoadPage ].	
			PvAction new 
				name: 'Versions';
				description: 'Browse versions of current playground page';
				iconCompositeName: 'versions';
				action: [ :aContext :aCommand | aContext doBrowseVersionsCommand: aCommand ].
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

{ #category : 'initialization' }
DockPlayground >> initialize [

	model := DockPlaygroundModel new.
	super initialize. 
	
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
	self ensureCodeBindings.
	codePresenter text: self model contents
]
