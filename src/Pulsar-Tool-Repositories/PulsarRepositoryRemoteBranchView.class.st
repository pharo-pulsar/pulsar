Class {
	#name : 'PulsarRepositoryRemoteBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories-View-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Branches'
}

{ #category : 'private' }
PulsarRepositoryRemoteBranchView >> branches [ 

	^ self model remoteBranches
]

{ #category : 'private - definitions' }
PulsarRepositoryRemoteBranchView >> defineExtraActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #extraActions with: [ :group | group 
		addActionWith: [ :action | action 
			dynamicName: [ 'Open remotes' ];
			iconName: #remotes;
			description: 'Open remotes view';
			action: [ self doOpenRemotes ] ] ]
]

{ #category : 'private - definitions' }
PulsarRepositoryRemoteBranchView >> defineGitActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #gitActions with: [ :group | group 
		priority: 1;
		addActionWith: [ :action | action 
			dynamicName: [ 'Merge branch {1} into {2} ' format: { self selectedItemName. self model headName } ];
			iconName: 'merge';
			description: 'Merge a a branch into current HEAD branch';
			actionEnabled: [
				self model isHeadInBranch 
					and: [ self hasSelectedItem
					and: [ self selectedItem isHead not ] ] ] ;
			action: [ self doMergeSelectedBranchIntoHead ] ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryRemoteBranchView >> doOpenRemotes [

	self notificationCenter announce: (PulsarRequestRepositoryRemotes on: self model)
]

{ #category : 'initialization' }
PulsarRepositoryRemoteBranchView >> initializePresenters [

	super initializePresenters.

	toolbarPresenter addPresenter: (self newToolbar
		displayMode: self application toolbarDisplayMode;
		fillWith: (self actions actionsFor: #extraActions))
]

{ #category : 'accessing' }
PulsarRepositoryRemoteBranchView >> label [

	^ 'remote branches'
]
