Class {
	#name : 'PulsarRepositoryBranchModel',
	#superclass : 'PulsarRepositoryBaseModel',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'instance creation' }
PulsarRepositoryBranchModel class >> on: aBranch [

	^ self basicNew
		branch: aBranch;
		initialize;
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryBranchModel >> branch [

	^ self entity
]

{ #category : 'accessing' }
PulsarRepositoryBranchModel >> incomingCommits [

	^ #()
]

{ #category : 'testing' }
PulsarRepositoryBranchModel >> isHead [

	^ self branch isHead
]

{ #category : 'accessing' }
PulsarRepositoryBranchModel >> name [

	^ self branch name
]

{ #category : 'accessing' }
PulsarRepositoryBranchModel >> outgoingCommits [
 
	^ #()
]
