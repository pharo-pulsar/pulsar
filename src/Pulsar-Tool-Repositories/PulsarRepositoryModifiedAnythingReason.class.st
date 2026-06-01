"
Fallback reason used when no specific operation triggered the announcement. Answers true to all affect queries so that all views refresh.
"
Class {
	#name : 'PulsarRepositoryModifiedAnythingReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedAnythingReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedAnythingReason >> affectsChanges [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedAnythingReason >> affectsCommits [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedAnythingReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedAnythingReason >> affectsTags [

	^ true
]
