Class {
	#name : 'PulsarRepositoryLocalBranchModel',
	#superclass : 'PulsarRepositoryBranchModel',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'accessing' }
PulsarRepositoryLocalBranchModel >> incomingCommits [

	^ self branch incomingCommits
]

{ #category : 'accessing' }
PulsarRepositoryLocalBranchModel >> outgoingCommits [
 
	self branch tracksRemoteBranch ifFalse: [ ^ #() ].

	^ self branch outgoingCommits
]
