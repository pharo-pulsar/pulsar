"
Reason for pull operations. Affects all repository aspects: changes, commits, branches, tags, and repository list.
"
Class {
	#name : 'PulsarRepositoryModifiedPullReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedPullReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedPullReason >> affectsChanges [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedPullReason >> affectsCommits [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedPullReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedPullReason >> affectsTags [

	^ true
]
