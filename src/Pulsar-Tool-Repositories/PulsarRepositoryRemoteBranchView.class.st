Class {
	#name : 'PulsarRepositoryRemoteBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Branches'
}

{ #category : 'nil' }
PulsarRepositoryRemoteBranchView >> branches [ 

	^ self model remoteBranches
]
