Class {
	#name : 'PulsarRepositoryLocalBranchModel',
	#superclass : 'PulsarRepositoryBranchModel',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
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
