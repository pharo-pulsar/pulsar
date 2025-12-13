Class {
	#name : 'DockRepositoryRemoteBranchView',
	#superclass : 'DockRepositoryBaseBranchView',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'nil' }
DockRepositoryRemoteBranchView >> branches [ 

	^ self model remoteBranches
]
