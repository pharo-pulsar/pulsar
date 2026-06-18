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
PulsarRepositoryCheckoutPreviewModel >> checkoutDiffNode [

	^ self diffNode
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
			  | fromRef toRef tree |
			  toRef := commitish.
			  fromRef := self repositoryModel entity workingCopy.
			  tree := (fromRef ifNil: [ toRef diffTo: nil ] ifNotNil: [ fromRef diffTo: toRef ]) tree.
			  diffNode := PulsarDiffRoot
	              newRepository: repositoryModel
	              from: fromRef
	              to: toRef
	              tree: tree ]
]

{ #category : 'actions - command' }
PulsarRepositoryCheckoutPreviewModel >> newCheckoutActionWithStrategy: aCheckoutStrategy [

	^ IceTipStandardAction new
		  repository: self repositoryModel entity;
		  onSuccessRepositoryModified;
		  action: [
			  aCheckoutStrategy committish: commitish.
			  aCheckoutStrategy diff: self diffNode entity.
			  self repositoryModel entity checkout: aCheckoutStrategy ];
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
