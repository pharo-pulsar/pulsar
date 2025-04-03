Class {
	#name : 'DockPlayground',
	#superclass : 'DockBaseView',
	#traits : 'DockTSnapshot',
	#classTraits : 'DockTSnapshot classTrait',
	#instVars : [
		'codePresenter',
		'toolbarPresenter',
		'page',
		'actionsPresenter'
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
		registerGroup: #tools with: {  
			PvAction new
				name: 'New page';
				description: 'Creayes a new playground page';
				action: [ :aContext | aContext doNewPage ].		
			PvAction new
				name: 'Load page';
				description: 'Load a playground page';
				action: [ :aContext | aContext doLoadPage ].		
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

	^ SpOverlayLayout new
		addOverlay: actionsPresenter withConstraints: [ :c | c vAlignStart; hAlignEnd ];
		child: codePresenter;
		yourself
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

	"toolbarPresenter := self instantiate: DockToolbarPresenter.
	toolbarPresenter addPresenterMenuButtonWith: (self actions actionsFor: #tools)."
	actionsPresenter := self newMenuButton
		addStyle: 'flat';
		icon: (self iconNamed: 'menu');
		actions: (self actions actionsFor: #tools);
		yourself.

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

{ #category : 'private' }
DockPlayground >> newInteractionModel [

	^ StPlaygroundInteractionModel new
]

{ #category : 'private' }
DockPlayground >> newSystemNavigation [

	^ self systemNavigation
		codePresenter: codePresenter;
		yourself
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
