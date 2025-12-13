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
	
	aBuilder addGroup: #gitActions with: [ :group | 
	
	]
]

{ #category : 'private' }
DockRepositoryLocalBranchView >> maybeSort: aCollection [

	^ aCollection sort: #isHead descending, #name ascending
]
