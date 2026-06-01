"
Reason for push operations. Affects commits, branches, and repository list.
"
Class {
	#name : 'PulsarRepositoryModifiedPushReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedPushReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedPushReason >> affectsChanges [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedPushReason >> affectsCommits [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedPushReason >> affectsRemoteBranches [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedPushReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedPushReason >> affectsTags [

	^ false
]
