Class {
	#name : 'DockRepositoryLocalBranchModel',
	#superclass : 'DockRepositoryBranchModel',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'accessing' }
DockRepositoryLocalBranchModel >> incomingCommits [

	^ self branch incomingCommits
]
