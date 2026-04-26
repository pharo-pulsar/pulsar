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

{ #category : 'instance creation' }
PulsarRepositoryLocalBranchModel >> newPullActionFrom: aRemote [
	| remote |

	remote := aRemote ifNil: [ self entity upstream remote ].
	^ IceTipStandardAction new 
		repository: self repository entity;
		message: ('Pulling from {1}' format: { remote name });
		action: [ self entity pullIntoBranchFrom: remote ];
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryLocalBranchModel >> outgoingCommits [
 
	self branch tracksRemoteBranch ifFalse: [ ^ #() ].

	^ self branch outgoingCommits
]
