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
			name: 'Fetch';
			description: 'Fetch remote repositories';
			iconName: 'fetch';
			action: [ :aContext | aContext doFetchRepositories ] ] ]
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
