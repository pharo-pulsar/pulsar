Class {
	#name : 'PulsarRepositoryBranchModel',
	#superclass : 'PulsarRepositoryBaseModel',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
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

{ #category : 'instance creation' }
PulsarRepositoryBranchModel >> newDiffModelToCommitishModel: aCommitishModel [

	^ PulsarRepositoryCommitDiffModel 
		newRepositoryModel: self repository
		from: self entity
		to: aCommitishModel entity
]

{ #category : 'instance creation' }
PulsarRepositoryBranchModel >> newDiffModelToWorkingCopy [

	^ PulsarRepositoryCommitDiffModel 
		newRepositoryModel: self repository
		from: self entity
		to: self repository entity workingCopy referenceCommit
]

{ #category : 'accessing' }
PulsarRepositoryBranchModel >> outgoingCommits [
 
	^ #()
]

{ #category : 'accessing' }
PulsarRepositoryBranchModel >> selectionAnnouncementClass [

	^ PulsarRepositoryBranchModelSelected
]
