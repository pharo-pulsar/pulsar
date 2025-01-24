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

{ #category : 'layout' }
DockPlayground >> defaultLayout [

	^ SpBoxLayout newVertical
		add: codePresenter;
		yourself
]

{ #category : 'initialization' }
DockPlayground >> initializePresenters [

	(codePresenter := self newCode)
		interactionModel: StPlaygroundInteractionModel new; 
		systemNavigation: (self systemNavigation
			codePresenter: codePresenter;
			yourself)		
		yourself
]

{ #category : 'initialization' }
DockPlayground >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: 'workspace')
]

{ #category : 'accessing' }
DockPlayground >> systemNavigation [ 

	self withWindowDo: [ :aWindow | 
		^ aWindow systemNavigation ].
	^ super systemNavigation
]
