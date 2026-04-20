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

	^ 1100@950
]

{ #category : 'private - definitions' }
PulsarRepositoryBrowser >> defineGlobalActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #gitGlobalActions with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Commit';
			iconName: 'commit';
			description: 'Commit selected changes';
			shortcutKey: $c actionModifier;
			actionEnabled: [ self model canCommit ];
			action: [ (PulsarRepositoryActionContext on: self) doCommit: self model ] ];
		addActionWith: [ :action | action 
			name: 'Push outgoing commits';
			iconName: 'push';
			shortcutKey: $p shift actionModifier;
			description: 'Push current branch outgoing commits to remote';
			action: [ (PulsarRepositoryActionContext on: self) doPush: self model ] ];
		addActionWith: [ :action | action 
			name: 'Pull incoming commits';
			iconName: 'pull';
			shortcutKey: $p actionModifier;
			description: 'Pull incoming commits from remote into current branch';
			action: [ (PulsarRepositoryActionContext on: self) doPull: self model ] ] ]
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
PulsarRepositoryBrowser >> viewDocked: aPresenter [

	(PulsarBrowserEnsureClassOverviewVisitor on: self) visit: aPresenter
]

{ #category : 'private' }
PulsarRepositoryBrowser >> windowClosed [

	super windowClosed.
	self model resetDiff
]
