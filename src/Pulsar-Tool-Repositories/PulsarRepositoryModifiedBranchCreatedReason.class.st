"
Reason for branch creation. Affects branches and repository list.
"
Class {
	#name : 'PulsarRepositoryModifiedBranchCreatedReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedBranchCreatedReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedBranchCreatedReason >> affectsChanges [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedBranchCreatedReason >> affectsCommits [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedBranchCreatedReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedBranchCreatedReason >> affectsTags [

	^ false
]
