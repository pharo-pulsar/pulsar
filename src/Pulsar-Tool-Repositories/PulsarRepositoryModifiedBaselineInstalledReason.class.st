"
Reason for installing baselines. Affects changes and repository list.
"
Class {
	#name : 'PulsarRepositoryModifiedBaselineInstalledReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'query' }
PulsarRepositoryModifiedBaselineInstalledReason >> affectsBranches [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedBaselineInstalledReason >> affectsChanges [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedBaselineInstalledReason >> affectsCommits [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedBaselineInstalledReason >> affectsRemoteBranches [

	^ false
]

{ #category : 'query' }
PulsarRepositoryModifiedBaselineInstalledReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedBaselineInstalledReason >> affectsTags [

	^ false
]
