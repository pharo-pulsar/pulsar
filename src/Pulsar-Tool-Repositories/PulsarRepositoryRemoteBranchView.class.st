Class {
	#name : 'PulsarRepositoryRemoteBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'nil' }
PulsarRepositoryRemoteBranchView >> branches [ 

	^ self model remoteBranches
]
