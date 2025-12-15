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

{ #category : 'accessing' }
DockRepositoryLocalBranchModel >> outgoingCommits [
 
	self branch tracksRemoteBranch ifFalse: [ ^ #() ].

	^ self branch outgoingCommits
]
