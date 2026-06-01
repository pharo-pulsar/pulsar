"
Reason for merge operations. Affects changes, commits, branches, and repository list.
"
Class {
	#name : 'PulsarRepositoryModifiedMergeReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedMergeReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedMergeReason >> affectsChanges [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedMergeReason >> affectsCommits [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedMergeReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedMergeReason >> affectsTags [

	^ false
]
