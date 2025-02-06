Class {
	#name : 'DockPlayground',
	#superclass : 'DockBaseView',
	#traits : 'DockTSnapshot',
	#classTraits : 'DockTSnapshot classTrait',
	#instVars : [
		'codePresenter'
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

{ #category : 'accessing' }
DockPlayground >> contents [

	^ codePresenter text
]

{ #category : 'accessing' }
DockPlayground >> contents: aString [

	codePresenter text: aString
]

{ #category : 'layout' }
DockPlayground >> defaultLayout [

	^ SpBoxLayout newVertical
		add: codePresenter;
		yourself
]

{ #category : 'initialization' }
DockPlayground >> ensureCodeBindings [

	(codePresenter interactionModel bindings 
		anySatisfy: [ :each | each key = #thisBrowser ])
		ifTrue: [ ^ self ].
		
	codePresenter interactionModel 
		addBinding: (WorkspaceVariable key: #thisBrowser value: self window)
]

{ #category : 'initialization' }
DockPlayground >> initializePresenters [

	(codePresenter := self newCode)
		interactionModel: self newInteractionModel; 
		systemNavigation: self newSystemNavigation;		
		yourself
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

	^ DockPlaygroundSnapshotRecord on: self
]

{ #category : 'accessing' }
DockPlayground >> systemNavigation [ 

	self withWindowDo: [ :aWindow | 
		^ aWindow systemNavigation ].
	^ super systemNavigation
]

{ #category : 'initialization' }
DockPlayground >> updatePresenter [ 

	super updatePresenter. 
	self ensureCodeBindings
]
