Class {
	#name : 'PulsarRepositoryLocalBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'private' }
PulsarRepositoryLocalBranchView >> branches [ 

	^ self model localBranches
]

{ #category : 'accessing - actions' }
PulsarRepositoryLocalBranchView >> defineActionsOn: aBuilder [
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
			action: [ self doCreateBranchCommand: action ] ];
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
PulsarRepositoryLocalBranchView >> doCreateBranchCommand: anAction [
	| dialog branchName |

	dialog := self instantiate: PulsarRequestPresenter.
	dialog 
		label: 'Branch Name';
		text: ''.
	dialog acceptLabel: 'Create'.
	
	dialog asPopover
		relativeTo: anAction presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].
	
	branchName := dialog text.
	
	self model switchToBranchNamed: branchName.
	self notifyRepositoryModified
]

{ #category : 'private - actions' }
PulsarRepositoryLocalBranchView >> doFetchRepositories [

	self scheduleJob: [
		self model newFetchAction
			onSuccess: [ self notifyRepositoryModified ];
			executeWithContext: self ]
]

{ #category : 'actions' }
PulsarRepositoryLocalBranchView >> doPull [

	(PulsarRepositoryActionContext on: self) doPull: self model
]

{ #category : 'actions' }
PulsarRepositoryLocalBranchView >> doPush [

	(PulsarRepositoryActionContext on: self) doPush: self model
]

{ #category : 'private' }
PulsarRepositoryLocalBranchView >> maybeSort: aCollection [

	^ aCollection sort: #isHead descending, #name ascending
]

{ #category : 'private' }
PulsarRepositoryLocalBranchView >> notifyRepositoryModified [

	"inform to all windows, as all may have things to do"
	self application resendAnnouncement: (PulsarRepositoryModified newValue: self model)
]
