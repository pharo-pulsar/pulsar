"
A browser for a git repository.
It should allow to commit, pull, push, etc.

The UI takes inspiration from lazygit (TUI), for its simplicity and power.
"
Class {
	#name : 'DockRepositoryBrowser',
	#superclass : 'DockBaseBrowser',
	#classVars : [
		'LastWindowSize'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'initialization' }
DockRepositoryBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		initialExtent: (LastWindowSize ifNil: [ 900@900 ]);
		whenResizingDo: [ :ann | LastWindowSize := ann newSize ];
		whenWillCloseDo: [ :ann | 
			self windowWillClose 
				ifFalse: [ ann denyClose ] ];
		whenClosedDo: [ self windowClosed ].
		
	aWindowPresenter title: ('{1} ({2})' format: { 
		self model name. 
		self model location fullName })
]

{ #category : 'initialization' }
DockRepositoryBrowser >> initializeWorkspace [

	super initializeWorkspace.
	
	self startWidth: 400.
		
	self addPresenterClass: DockRepositoryChangesView model: self model
]
