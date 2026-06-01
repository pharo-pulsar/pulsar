"
Reason for commit operations. Affects changes, commits, and repository list.
"
Class {
	#name : 'PulsarRepositoryModifiedCommitReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedCommitReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedCommitReason >> affectsChanges [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedCommitReason >> affectsCommits [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedCommitReason >> affectsRemoteBranches [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedCommitReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedCommitReason >> affectsTags [

	^ false
]
