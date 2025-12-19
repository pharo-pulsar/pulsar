"
A browser for a git repository.
It should allow to commit, pull, push, etc.

The UI takes inspiration from lazygit (TUI), for its simplicity and power.
"
Class {
	#name : 'DockRepositoryBrowser',
	#superclass : 'DockBaseBrowser',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'accessing - defaults' }
DockRepositoryBrowser class >> defaultWindowSize [

	^ 900@900
]

{ #category : 'private - definitions' }
DockRepositoryBrowser >> defineExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #extra with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'New Payground';
			description: 'Open a new playground';
			action: [ self doNewPlayground ] ] ]
]

{ #category : 'private - actions' }
DockRepositoryBrowser >> doNewPlayground [

	self notificationCenter announce: DockRequestNewPlayground
]

{ #category : 'initialization' }
DockRepositoryBrowser >> initializeDefaultWorkspace [
			
	self addPresenterClass: DockRepositoryChangesView model: self model.
	self addPresenterClass: DockRepositoryPackagesView model: self model.
	self addPresenterClass: DockRepositoryBranchesView model: self model.
	self addPresenterClass: DockRepositoryCommitsView model: self model.
	
	"this I will maybe need it with variables"
	self addPresenterClass: DockRepositoryDiffEditor
]

{ #category : 'initialization' }
DockRepositoryBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.		
	aWindowPresenter title: ('{1} ({2})' format: { 
		self model name. 
		self model location fullName })
]

{ #category : 'initialization' }
DockRepositoryBrowser >> initializeWorkspace [

	super initializeWorkspace.
	
	self startWidth: 400
]

{ #category : 'initialization' }
DockRepositoryBrowser >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: DockRequestToolAnnouncement send: #addTool: to: self
]

{ #category : 'accessing - snapshot' }
DockRepositoryBrowser >> snapshot [

	^ DockRepositoryBrowserSnapshot on: self
]

{ #category : 'private' }
DockRepositoryBrowser >> windowClosed [

	super windowClosed.
	self model resetDiff
]
