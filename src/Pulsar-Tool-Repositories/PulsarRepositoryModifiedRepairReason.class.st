"
Reason for repair operations. Affects all repository aspects.
"
Class {
	#name : 'PulsarRepositoryModifiedRepairReason',
	#superclass : 'PulsarRepositoryModifiedReason',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'query' }
PulsarRepositoryModifiedRepairReason >> affectsBranches [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedRepairReason >> affectsChanges [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedRepairReason >> affectsCommits [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedRepairReason >> affectsRepositoryList [

	^ true
]

{ #category : 'query' }
PulsarRepositoryModifiedRepairReason >> affectsTags [

	^ true
]
