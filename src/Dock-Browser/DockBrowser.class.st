Class {
	#name : 'DockBrowser',
	#superclass : 'DockBaseBrowser',
	#instVars : [
		'projectView',
		'outlineView'
	],
	#classVars : [
		'LastWindowSize'
	],
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing - actions' }
DockBrowser class >> defineActionsOn: aBuilder [
	<perspectiveActions>

	aBuilder registerGroup: #perspective with: { 
		"open default tool"
		Character cr shift -> DockShowSpotterForEnvironmentCommand new.
		Character cr shift mod1 -> DockShowSpotterForWindowsCommand new.
		"Character mod1 mod3 -> PvShowSpotterForCommandsAction new" }
]

{ #category : 'initialization' }
DockBrowser >> addViewClass: aClass [

	^ self addViewClass: aClass on: nil
]

{ #category : 'initialization' }
DockBrowser >> addViewClass: aClass on: aModel [
	| view |

	view := self instantiate: aClass on: aModel.
	self addPresenter: view at: view dockPosition.
	^ view
]

{ #category : 'api - focus' }
DockBrowser >> defaultKeyboardFocus [

	^ projectView
]

{ #category : 'events' }
DockBrowser >> eventModelActivated: anAnnouncement [
	
	
	self maybeDockView: anAnnouncement value
]

{ #category : 'private' }
DockBrowser >> findEditorContaining: aViewModel [

	^ self editors 
		detect: [ :each | each presenter model = aViewModel ]
		ifNone: [ nil ]
]

{ #category : 'initialization' }
DockBrowser >> initialExtent [

	^ LastWindowSize ifNil: [ super initialExtent ]
]

{ #category : 'initialization' }
DockBrowser >> initialize [

	self setModelBeforeInitialization: PvEnvironmentModel onSystem.
	super initialize
]

{ #category : 'initialization' }
DockBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		initialExtent: (LastWindowSize ifNil: [ 1000@800 ]);
		whenResizingDo: [ :ann | LastWindowSize := ann newSize ];
		whenWillCloseDo: [ :ann | 
			self windowWillClose 
				ifFalse: [ ann denyClose ] ]
]

{ #category : 'initialization' }
DockBrowser >> initializeWorkspace [

	self startWidth: 280"self initialExtent x * 25 percent".
	self endWidth: 280"self initialExtent x * 25 percent".
	self bottomHeight: 180"self initialExtent y * 20 percent".
	
	"I need a better control on these one"
	projectView := self addViewClass: DockProjectView on: self model newMultiProjectModel.
	outlineView := self addViewClass: DockClassOutlineView.

	"here, the list of components that are part of the 'sides' but we access 
	 just while interacting."	
	{ DockStackView. DockPlayground. DockTranscript } 
		do: [ :eachClass | self addViewClass: eachClass ]
]

{ #category : 'private' }
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
			takeKeyboardFocus.
		^ self ].

	editorPresenter := self 
		instantiate: aViewModel dockEditorClass
		on: aViewModel. 
	self 
		addPresenter: editorPresenter 
		at: editorPresenter dockPosition
]

{ #category : 'actions' }
DockBrowser >> openClass: aClass [ 

	self projectView notifyActivateEntity: (PvClassModel 
		newEnvironment: self model environmentModel
		entity: aClass)
]

{ #category : 'actions' }
DockBrowser >> openProject: aBaselineClass [ 

	projectView addProject: aBaselineClass
]

{ #category : 'private' }
DockBrowser >> outlineView [

	^ outlineView
]

{ #category : 'private' }
DockBrowser >> presenterWithClass: aClass [
	"used for testing"

	^ self presenters 
		detect: [ :each | each presenter class = aClass ]
		ifNone: [ nil ]
]

{ #category : 'private' }
DockBrowser >> presenterWithTitle: aString [

	^ self presenters 
		detect: [ :each | each title = aString ]
		ifNone: [ nil ]
]

{ #category : 'private' }
DockBrowser >> projectView [

	^ projectView
]

{ #category : 'initialization' }
DockBrowser >> updateTitle [

	self title: (projectView openedProjects
		ifNotEmpty: [ :projectModels | 
			'Pharo({1}): {2}' format: { 
				FileLocator image base.
				(projectModels collect: #name) asCommaString } ]
		ifEmpty: [ 
			'Pharo({1})' format: { FileLocator image base } ])
]

{ #category : 'private' }
DockBrowser >> windowClosed [

	self presenters do: [ :each | each windowClosed ].	
	super windowClosed
]
