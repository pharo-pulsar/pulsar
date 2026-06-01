"
Reason for fetch operations. Affects branches, tags, and repository list.
"
Class {
	#name : 'PulsarRepositoryModifiedFetchReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedFetchReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedFetchReason >> affectsChanges [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedFetchReason >> affectsCommits [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedFetchReason >> affectsRemoteBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedFetchReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedFetchReason >> affectsTags [

	^ true
]
