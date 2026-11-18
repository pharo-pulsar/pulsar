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

{ #category : 'private' }
PulsarRepositoryCheckoutPreviewModel >> checkoutCommitish: aCommitish diffTo: aDiffCommitish strategy: aCheckoutStrategy [

	^ self
		  checkoutCommitish: aCommitish
		  withDiff: (self newDiffNodeTo: aDiffCommitish) entity
		  strategy: aCheckoutStrategy
]

{ #category : 'private' }
PulsarRepositoryCheckoutPreviewModel >> checkoutCommitish: aCommitish withDiff: aDiff strategy: aCheckoutStrategy [

	aCheckoutStrategy
		committish: aCommitish;
		diff: aDiff.
	^ aCommitish checkout: aCheckoutStrategy
]

{ #category : 'actions - command' }
PulsarRepositoryCheckoutPreviewModel >> checkoutConflictBetween: aLocalBranch and: aRemoteBranch strategy: aCheckoutStrategy context: aContext [
	| resolution |

	resolution := self
		resolutionForConflictBetween: aLocalBranch
		and: aRemoteBranch
		context: aContext.
	resolution ifNil: [ ^ nil ].
	
	resolution key = #checkoutLocal ifTrue: [
		^ self checkoutCommitish: aLocalBranch diffTo: aLocalBranch strategy: aCheckoutStrategy ].
	resolution key = #newBranch ifTrue: [
		^ self
			  checkoutNewLocalBranchNamed: resolution value
			  at: aRemoteBranch
			  strategy: aCheckoutStrategy ].
	resolution key = #resetLocal ifTrue: [
		^ self
			  resetLocalBranch: aLocalBranch
			  to: aRemoteBranch
			  strategy: aCheckoutStrategy ].
		
	self error: f'Unknown checkout resolution: [resolution key]' 
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> checkoutDiffNode [

	^ self diffNode
]

{ #category : 'private' }
PulsarRepositoryCheckoutPreviewModel >> checkoutNewLocalBranchNamed: aString at: aRemoteBranch strategy: aCheckoutStrategy [
	| diff localBranch |

	diff := (self newDiffNodeTo: aRemoteBranch) entity.
	
	localBranch := self repositoryModel 
		createBranch: aString 
		fromCommit: aRemoteBranch commit.
	localBranch setUpstream: aRemoteBranch.

	^ self
		  checkoutCommitish: localBranch
		  withDiff: diff
		  strategy: aCheckoutStrategy
]

{ #category : 'actions - command' }
PulsarRepositoryCheckoutPreviewModel >> checkoutRemoteBranch: aRemoteBranch strategy: aCheckoutStrategy context: aContext [

	| localBranch |

	localBranch := self localBranchFor: aRemoteBranch.
	localBranch
		ifNil: [
			^ self
				  checkoutNewLocalBranchNamed: aRemoteBranch shortName
				  at: aRemoteBranch
				  strategy: aCheckoutStrategy ].
	aRemoteBranch commit = localBranch commit
		ifTrue: [ ^ self checkoutCommitish: localBranch diffTo: localBranch strategy: aCheckoutStrategy ].
	^ self
		  checkoutConflictBetween: localBranch
		  and: aRemoteBranch
		  strategy: aCheckoutStrategy
		  context: aContext
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> checkoutStrategies [

	^ IceCheckoutStrategy allStrategies
]

{ #category : 'actions - command' }
PulsarRepositoryCheckoutPreviewModel >> checkoutWithStrategy: aCheckoutStrategy context: aContext [

	(commitish isBranch and: [ commitish isRemote ])
		ifFalse: [ ^ self checkoutCommitish: commitish diffTo: commitish strategy: aCheckoutStrategy ].
	^ self
		  checkoutRemoteBranch: commitish
		  strategy: aCheckoutStrategy
		  context: aContext
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> commitish: anIceCommitish [

	commitish := anIceCommitish
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> diffNode [

	^ diffNode ifNil: [ diffNode := self newDiffNodeTo: commitish ]
]

{ #category : 'private' }
PulsarRepositoryCheckoutPreviewModel >> localBranchFor: aRemoteBranch [

	^ self repositoryModel entity localBranches
		  detect: [ :each | each name = aRemoteBranch shortName ]
		  ifNone: [ nil ]
]

{ #category : 'actions - command' }
PulsarRepositoryCheckoutPreviewModel >> newCheckoutActionWithStrategy: aCheckoutStrategy [

	^ IceTipStandardAction new
		  repository: self repositoryModel entity;
		  onSuccessRepositoryModified;
		  action: [ :context |
			  self
				  checkoutWithStrategy: aCheckoutStrategy
				  context: context ];
		  yourself
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> newDiffNodeTo: aCommitish [

	| fromRef toRef tree |

	toRef := aCommitish.
	fromRef := self repositoryModel entity workingCopy.
	tree := (fromRef
		         ifNil: [ toRef diffTo: nil ]
		         ifNotNil: [ fromRef diffTo: toRef ]) tree.
	^ PulsarDiffRoot
		  newRepository: repositoryModel
		  from: fromRef
		  to: toRef
		  tree: tree
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> repositoryModel [

	^ repositoryModel
]

{ #category : 'accessing' }
PulsarRepositoryCheckoutPreviewModel >> repositoryModel: aRepositoryModel [

	repositoryModel := aRepositoryModel
]

{ #category : 'private' }
PulsarRepositoryCheckoutPreviewModel >> resetLocalBranch: aLocalBranch to: aRemoteBranch strategy: aCheckoutStrategy [

	| diff |

	diff := (self newDiffNodeTo: aRemoteBranch) entity.
	aLocalBranch commit: aRemoteBranch commit.
	^ self
		  checkoutCommitish: aLocalBranch
		  withDiff: diff
		  strategy: aCheckoutStrategy
]

{ #category : 'private' }
PulsarRepositoryCheckoutPreviewModel >> resolutionForConflictBetween: aLocalBranch and: aRemoteBranch context: aContext [

	| dialog |

	aContext ifNil: [ ^ #checkoutLocal -> nil ].
	dialog := aContext instantiate: PulsarRepositoryCheckoutConflictDialog.
	dialog
		remoteBranch: aRemoteBranch;
		existingBranch: aLocalBranch.
	(dialog openModalWithParent: aContext window) isOk ifFalse: [ ^ nil ].
	^ dialog resolution -> dialog newBranchName
]
