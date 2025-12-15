Class {
	#name : 'DockRepositoryLocalBranchView',
	#superclass : 'DockRepositoryBaseBranchView',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'private' }
DockRepositoryLocalBranchView >> branches [ 

	^ self model localBranches
]

{ #category : 'accessing - actions' }
DockRepositoryLocalBranchView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #gitActions with: [ :group | group 
		addActionWith: [ :action | action 
			name: 'Fetch remotes';
			description: 'Fetch remote repositories';
			iconName: 'fetch';
			action: [ :aContext | aContext doFetchRepositories ] ];
		addActionWith: [ :action | action 
			dynamicName: [ 'Create branch from {1}' format: { self selectedItemName } ];
			iconName: 'branch';
			description: 'Create a new branch from current HEAD';
			shortcutKey: $b actionModifier;
			actionEnabled: [ self hasSelectedItem and: [ self selectedItem isHead ] ];
			action: [ self doCreateBranch ] ];
		addActionWith: [ :action | action 
			dynamicName: [ 'Merge branch {1} into {2} ' format: { self selectedItemName. self model headName } ];
			iconName: 'merge';
			description: 'Merge a a branch into current HEAD branch';
			actionEnabled: [
				self model isHeadInBranch 
					and: [ self hasSelectedItem
					and: [ self selectedItem isHead not ] ] ] ;
			action: [ self doMergeIntoHead ] ];
		addActionWith: [ :action | action 
			name: 'Push outgoing commits';
			iconName: 'push';
			shortcutKey: $p shift actionModifier;
			description: 'Push current branch outgoing commits to remote';
			action: [ self doPush ] ];
		addActionWith: [ :action | action 
			name: 'Pull incoming commits';
			iconName: 'pull';
			shortcutKey: $p actionModifier;
			description: 'Pull incoming commits from remote into current branch';
			action: [ self doPull ] ] ]
]

{ #category : 'private - actions' }
DockRepositoryLocalBranchView >> doFetchRepositories [

	self scheduleJob: [
		self model newFetchAction
			onSuccess: [ self repositoryModified ];
			executeWithContext: self ]
]

{ #category : 'private' }
DockRepositoryLocalBranchView >> maybeSort: aCollection [

	^ aCollection sort: #isHead descending, #name ascending
]

{ #category : 'private' }
DockRepositoryLocalBranchView >> repositoryModified [

	"inform to all windows, as all may have things to do"
	self application resendAnnouncement: (DockRepositoryModified newValue: self model)
]
