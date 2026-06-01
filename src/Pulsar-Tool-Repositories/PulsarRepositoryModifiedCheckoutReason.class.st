"
Reason for checkout operations. Affects changes, commits, branches, and repository list.
"
Class {
	#name : 'PulsarRepositoryModifiedCheckoutReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedCheckoutReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedCheckoutReason >> affectsChanges [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedCheckoutReason >> affectsCommits [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedCheckoutReason >> affectsRemoteBranches [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedCheckoutReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedCheckoutReason >> affectsTags [

	^ false
]
