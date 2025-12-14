Class {
	#name : 'DockRepositoryBranchModel',
	#superclass : 'DockRepositoryBaseModel',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'instance creation' }
DockRepositoryBranchModel class >> on: aBranch [

	^ self basicNew
		branch: aBranch;
		initialize;
		yourself
]

{ #category : 'accessing' }
DockRepositoryBranchModel >> branch [

	^ self entity
]

{ #category : 'accessing' }
DockRepositoryBranchModel >> incomingCommits [

	^ #()
]

{ #category : 'testing' }
DockRepositoryBranchModel >> isHead [

	^ self branch isHead
]

{ #category : 'accessing' }
DockRepositoryBranchModel >> name [

	^ self branch name
]

{ #category : 'accessing' }
DockRepositoryBranchModel >> outgoingCommits [
 
	^ #()
]
