"
Reason for remote tracking branch removal. Affects remote branches and repository list, but not local branches.
"
Class {
	#name : 'PulsarRepositoryModifiedRemoteBranchRemovedReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedRemoteBranchRemovedReason >> affectsBranches [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedRemoteBranchRemovedReason >> affectsChanges [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedRemoteBranchRemovedReason >> affectsCommits [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedRemoteBranchRemovedReason >> affectsRemoteBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedRemoteBranchRemovedReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedRemoteBranchRemovedReason >> affectsTags [

	^ false
]
