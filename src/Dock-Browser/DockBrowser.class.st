Class {
	#name : 'DockBrowser',
	#superclass : 'DockBaseBrowser',
	#instVars : [
		'projectView'
	],
	#classVars : [
		'LastWindowSize'
	],
	#category : 'Dock-Browser-Base',
	#package : 'Dock-Browser',
	#tag : 'Base'
}

{ #category : 'events' }
DockBrowser >> eventModelActivated: anAnnouncement [
	
	
	self maybeDockView: anAnnouncement value
]

{ #category : 'as yet unclassified' }
DockBrowser >> findEditorContaining: aViewModel [

	^ 	self presenters 
		detect: [ :each | each presenter  model = aViewModel ]
		ifNone: [ nil ]
]

{ #category : 'initialization' }
DockBrowser >> initialize [

	self setModelBeforeInitialization: PvEnvironmentModel onSystem.
	super initialize
]

{ #category : 'initialization' }
DockBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		initialExtent: (LastWindowSize ifNil: [ 900@600 ]);
		title: 'Pharo Dock';
		whenResizingDo: [ :ann | LastWindowSize := ann newSize ]
]

{ #category : 'initialization' }
DockBrowser >> initializeWorkspace [

	self startWidth: self initialExtent x * 30 percent.
	self endWidth: self initialExtent x * 30 percent.
	
	"I need a better control on these one"
	projectView := self 
		instantiate: DockProjectView 
		on: self model newMultiProjectModel.
	self addPresenter: projectView at: projectView dockPosition.

	"here, the list of components that are part of the 'sides' but we access 
	 just while interacting."	
	{ DockClassOutlineView } do: [ :eachClass |
		| view |
		view := self instantiate: eachClass.
		self 
			addPresenter: view 
			at: view dockPosition ]
]

{ #category : 'actions' }
DockBrowser >> maybeDockView: aViewModel [
	"if the entity has an editor associated:
	 	if the entity is not already there, open it.
	 	if the entity is already opened, 
			if it can have multiple views: open it.
			if it is single view: select it
	 otherwise ignore it"
	| editorPresenter |
	
	aViewModel hasDockEditor ifFalse: [ ^ self ].
	
	(self findEditorContaining: aViewModel) ifNotNil: [ :panelPresenter | 
		panelPresenter 
			raise; 
			takeKeyboardFocus ].

	editorPresenter := self 
		instantiate: aViewModel dockEditorClass
		on: aViewModel. 
	self 
		addPresenter: editorPresenter 
		at: editorPresenter dockPosition
]

{ #category : 'actions' }
DockBrowser >> openProject: aBaselineClass [ 

	projectView addProject: aBaselineClass
]
