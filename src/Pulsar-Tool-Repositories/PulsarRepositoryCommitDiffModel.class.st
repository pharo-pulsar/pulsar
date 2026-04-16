Class {
	#name : 'PulsarRepositoryCommitDiffModel',
	#superclass : 'Object',
	#instVars : [
		'repositoryModel',
		'diffNode',
		'entity',
		'fromEntity',
		'toEntity'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarRepositoryCommitDiffModel class >> newRepositoryModel: aRepositoryModel from: aCommitish [

	^ self new
		repositoryModel: aRepositoryModel;
		from: aCommitish;
		yourself
]

{ #category : 'instance creation' }
PulsarRepositoryCommitDiffModel class >> newRepositoryModel: aRepositoryModel from: fromCommitish to: toCommitish [

	^ self new
		repositoryModel: aRepositoryModel;
		from: fromCommitish;
		to: toCommitish;
		yourself
]

{ #category : 'private' }
PulsarRepositoryCommitDiffModel >> calculateTreeToShow [

	^ (IceDiff 
		from: self fromEntity
		to: self toEntity)
		tree
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> diffNode [

	^ diffNode ifNil: [
		diffNode := PulsarDiffNode
			newRepository: repositoryModel
			entity: self calculateTreeToShow.
		diffNode from: self toEntity to: self fromEntity.
		diffNode ]
]

{ #category : 'instance creation' }
PulsarRepositoryCommitDiffModel >> from: aCommitish [

	fromEntity := aCommitish
]

{ #category : 'private' }
PulsarRepositoryCommitDiffModel >> fromEntity [

	^ fromEntity
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> fullName [

	^ '{1}: Diff from {2} to {3}' format: {
		self repositoryModel name. 
		self fromEntity shortId. 
		self toEntity shortId }
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> repositoryModel [

	^ repositoryModel
]

{ #category : 'accessing' }
PulsarRepositoryCommitDiffModel >> repositoryModel: aRepositoryModel [

	repositoryModel := aRepositoryModel
]

{ #category : 'instance creation' }
PulsarRepositoryCommitDiffModel >> to: aCommitish [

	toEntity := aCommitish
]

{ #category : 'private' }
PulsarRepositoryCommitDiffModel >> toEntity [

	^ toEntity ifNil: [ fromEntity parent ]
]
