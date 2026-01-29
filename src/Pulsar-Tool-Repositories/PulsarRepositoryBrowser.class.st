"
A browser for a git repository.
It should allow to commit, pull, push, etc.

The UI takes inspiration from lazygit (TUI), for its simplicity and power.
"
Class {
	#name : 'PulsarRepositoryBrowser',
	#superclass : 'PulsarBaseBrowser',
	#category : 'Pulsar-Tool-Repositories-View-Repository',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repository'
}

{ #category : 'accessing - defaults' }
PulsarRepositoryBrowser class >> defaultWindowSize [

	^ 1000@900
]

{ #category : 'initialization' }
PulsarRepositoryBrowser >> initializeDefaultWorkspace [
			
	self addPresenterClass: PulsarRepositoryChangesView model: self model.
	self addPresenterClass: PulsarRepositoryPackagesView model: self model.
	self addPresenterClass: PulsarRepositoryBranchesView model: self model.
	self addPresenterClass: PulsarRepositoryCommitsView model: self model.
	
	"this I will maybe need it with variables"
	self addPresenterClass: PulsarRepositoryDiffEditor
]

{ #category : 'initialization' }
PulsarRepositoryBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.		
	aWindowPresenter title: ('{1} ({2})' format: { 
		self model name. 
		self model location fullName })
]

{ #category : 'initialization' }
PulsarRepositoryBrowser >> initializeWorkspace [

	super initializeWorkspace.
	
	self startWidth: 400
]

{ #category : 'initialization' }
PulsarRepositoryBrowser >> registerToEvents [

	super registerToEvents
]

{ #category : 'accessing - snapshot' }
PulsarRepositoryBrowser >> snapshot [

	^ PulsarRepositoryBrowserSnapshot on: self
]

{ #category : 'private' }
PulsarRepositoryBrowser >> windowClosed [

	super windowClosed.
	self model resetDiff
]
