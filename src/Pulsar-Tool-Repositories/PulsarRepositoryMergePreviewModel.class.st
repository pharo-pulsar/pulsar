Class {
	#name : 'PulsarRepositoryMergePreviewModel',
	#superclass : 'Object',
	#instVars : [
		'repositoryModel',
		'branchModel',
		'mergeAction',
		'diffNode'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarRepositoryMergePreviewModel class >> repositoryModel: aRepositoryModel branchModel: aBranchModel [

	^ self new
		repositoryModel: aRepositoryModel;
		branchModel: aBranchModel;
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryMergePreviewModel >> branchModel: aBranchModel [

	branchModel := aBranchModel
]

{ #category : 'accessing' }
PulsarRepositoryMergePreviewModel >> diffNode [

	^ diffNode ifNil: [
		diffNode := PulsarDiffNode
			newRepository: repositoryModel
			entity: self mergeAction treeToShow ]
]

{ #category : 'private' }
PulsarRepositoryMergePreviewModel >> mergeAction [

	^ mergeAction ifNil: [
		mergeAction := IceMerge new
			repository: repositoryModel entity;
			mergeCommit: branchModel entity commit;
			yourself ]
]

{ #category : 'actions - command' }
PulsarRepositoryMergePreviewModel >> newMergeAction [

	^ IceTipStandardAction new
		repository: repositoryModel entity;
		message: ('Merging branch {1} from {2}' format: { branchModel name. repositoryModel name });
		onSuccessRepositoryModified;
		action: [ branchModel entity switchAndMergeWorkingCopy ];
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryMergePreviewModel >> repositoryModel: aRepositoryModel [

	repositoryModel := aRepositoryModel
]

{ #category : 'accessing' }
PulsarRepositoryMergePreviewModel >> repositoryModel [

	^ repositoryModel
]
