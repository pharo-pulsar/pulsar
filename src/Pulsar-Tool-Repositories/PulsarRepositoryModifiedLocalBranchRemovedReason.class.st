"
Reason for local branch removal. Affects local branches and repository list, but not remote branches.
"
Class {
	#name : 'PulsarRepositoryModifiedLocalBranchRemovedReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedLocalBranchRemovedReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedLocalBranchRemovedReason >> affectsChanges [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedLocalBranchRemovedReason >> affectsCommits [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedLocalBranchRemovedReason >> affectsRemoteBranches [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedLocalBranchRemovedReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedLocalBranchRemovedReason >> affectsTags [

	^ false
]
