Class {
	#name : 'PulsarRepositoryRemoteBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories-View-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Branches'
}

{ #category : 'nil' }
PulsarRepositoryRemoteBranchView >> branches [ 

	^ self model remoteBranches
]

{ #category : 'accessing - actions' }
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

{ #category : 'accessing' }
PulsarRepositoryRemoteBranchView >> label [

	^ 'remote branches'
]
