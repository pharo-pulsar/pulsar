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

{ #category : 'private - definitions' }
PulsarRepositoryRemoteBranchView >> defineRemoveBranchActionOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #removeActions with: [ :group | group
		priority: 50;
		addActionWith: [ :action | action
			dynamicName: [ 'Remove {1}' format: { self selectedItemName } ];
			description: 'Delete this remote tracking branch';
			iconName: 'remove';
			actionEnabled: [ self hasSelectedItem and: [ self selectedItem isHead not ] ];
			action: [ self doRemoveSelectedBranch ] ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryRemoteBranchView >> doOpenRemotes [

	self notificationCenter announce: (PulsarRequestRepositoryRemotes on: self model)
]

{ #category : 'private - actions' }
PulsarRepositoryRemoteBranchView >> doRemoveSelectedBranch [

	| selected |
	selected := self selectedItem.
	selected ifNil: [ ^ self ].

	(self application newConfirm
		 title: 'Remove remote branch';
		 message: ('Are you sure you want to delete remote branch "{1}"?' format: { selected name });
		 acceptLabel: 'Delete';
		 openModalWithParent: self window) ifFalse: [ ^ self ].

	(self model newRemoveRemoteBranchAction: selected)
		onSuccess: [ self notifyRepositoryModified: PulsarRepositoryModifiedReason remoteBranchRemoved ];
		executeWithContext: self
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
