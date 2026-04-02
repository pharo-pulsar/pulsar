Class {
	#name : 'PulsarRepositoryCheckoutPreviewModel',
	#superclass : 'Object',
	#instVars : [
		'repositoryModel',
		'commitish',
		'diffNode'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarRepositoryCheckoutPreviewModel class >> repositoryModel: aRepositoryModel commitish: anIceCommitish [

	^ self new
		repositoryModel: aRepositoryModel;
		commitish: anIceCommitish;
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> checkoutStrategies [

	^ IceCheckoutStrategy allStrategies
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> commitish: anIceCommitish [

	commitish := anIceCommitish
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> diffNode [

	^ diffNode ifNil: [
		diffNode := PulsarDiffNode
			newRepository: repositoryModel
			entity: (commitish diffTo: repositoryModel entity workingCopy) tree ]
]

{ #category : 'actions - command' }
PulsarRepositoryCheckoutPreviewModel >> newCheckoutActionWithStrategy: aCheckoutStrategy [

	^ IceTipStandardAction new
		repository: repositoryModel entity;
		onSuccessRepositoryModified;
		action: [ commitish checkoutWithStrategy: aCheckoutStrategy ];
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> repositoryModel [

	^ repositoryModel
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> repositoryModel: aRepositoryModel [

	repositoryModel := aRepositoryModel
]
