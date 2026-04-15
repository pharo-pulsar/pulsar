Class {
	#name : 'PulsarRepositoryCommitDiffModel',
	#superclass : 'Object',
	#instVars : [
		'repositoryModel',
		'diffNode',
		'entity'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarRepositoryCommitDiffModel class >> newRepositoryModel: aRepositoryModel entity: aCommit [

	^ self new
		repositoryModel: aRepositoryModel;
		entity: aCommit;
		yourself
]

{ #category : 'private' }
PulsarRepositoryCommitDiffModel >> calculateTreeToShow [

	^ (IceDiff 
		from: entity
		to: entity parent)
		tree
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> commitModel: aCommitModel [

	entity := aCommitModel
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> diffNode [

	^ diffNode ifNil: [
		diffNode := PulsarDiffNode
			newRepository: repositoryModel
			entity: self calculateTreeToShow.
		diffNode from: entity parent to: entity.
		diffNode ]
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> entity: aCommit [

	entity := aCommit
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> fullName [

	^ '{1}: Diff from {2} to {3} (parent)' format: {
		self repositoryModel name. 
		entity shortId. 
		entity parent shortId }
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> repositoryModel [

	^ repositoryModel
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> repositoryModel: aRepositoryModel [

	repositoryModel := aRepositoryModel
]
