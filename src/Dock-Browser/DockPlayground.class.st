Class {
	#name : 'DockPlayground',
	#superclass : 'DockBaseView',
	#instVars : [
		'codePresenter'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'defaults' }
DockPlayground class >> defaultDockPosition [

	^ DockPanelPosition new 
		area: DockArea bottom;
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

	codePresenter := self newCode 
		beForScripting;
		yourself
]

{ #category : 'initialization' }
DockPlayground >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: 'workspace')
]
