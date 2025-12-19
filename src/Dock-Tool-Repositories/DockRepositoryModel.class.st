Class {
	#name : 'DockRepositoryModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'diff',
		'diffNode',
		'mutex'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'private' }
DockRepositoryModel >> activeNodes [

	^ Array streamContents: [ :stream | 
		self diffNode withAllChildrenDo: [ :each | 
			each isActive 
				ifTrue: [ stream nextPut: each node ] ] ]
]

{ #category : 'accessing' }
DockRepositoryModel >> commitsTo: aNumber [

	self entity isValid ifFalse: [ ^ #() ].

	^ Array new: aNumber streamContents: [ :stream | 
		| count |
		count := 0.
		self critical: [
			self entity branch commitsDo: [ :aCommit | 
				count < aNumber ifTrue: [ 
					stream nextPut: (DockRepositoryCommitModel 
						newRepository: self 
						entity: aCommit).
					count := count + 1 ] ] ] ]
]

{ #category : 'private' }
DockRepositoryModel >> critical: aBlock [

	^ self mutex critical: aBlock
]

{ #category : 'accessing' }
DockRepositoryModel >> diffNode [

	self entity isValid ifFalse: [ ^ DockDiffNode newRepository: self entity: IceNode new ].

	^ diffNode ifNil: [ 
		diffNode := DockDiffNode 
			newRepository: self
			entity: self diffToReferenceCommit tree ]
]

{ #category : 'accessing' }
DockRepositoryModel >> diffToReferenceCommit [

	^ diff ifNil: [ 
		diff := self critical: [ 
			self entity workingCopy diffToReferenceCommit ] ]
]

{ #category : 'testing' }
DockRepositoryModel >> hasUpstream [

	^ self entity branch hasUpstream
]

{ #category : 'accessing' }
DockRepositoryModel >> headName [

	^ self critical: [ self entity head name ]
]

{ #category : 'accessing' }
DockRepositoryModel >> incomingCommits [

	(self entity isValid and: [ self entity canPush ]) ifFalse: [ ^ #() ].

	^ self critical: [  
		self entity branch 
			ifNotNil: [ :aBranch | aBranch incomingCommits ]
			ifNil: [ #() ] ]
]

{ #category : 'testing' }
DockRepositoryModel >> isDetached [

	^ self entity workingCopy isDetached 
		or: [ self entity head isDetached ]
]

{ #category : 'testing' }
DockRepositoryModel >> isHeadInBranch [

	^ self critical: [ self entity head isBranch ]
]

{ #category : 'testing' }
DockRepositoryModel >> isMissing [

	^ self entity isMissing
]

{ #category : 'testing' }
DockRepositoryModel >> isOutgoingCommit: aCommitModel [

	self entity isValid ifFalse: [ ^ false ].

	self entity outgoingCommits ifNotEmpty: [ :aCollection | 
		^ aCollection anySatisfy: [ :each |
			each id = aCommitModel commit id ] ].

	^ false
]

{ #category : 'accessing' }
DockRepositoryModel >> localBranches [
	| branches |

	self entity isValid ifFalse: [ ^ #() ].

	branches := self critical: [ self entity localBranches ].
	^ branches collect: [ :each | 
		DockRepositoryLocalBranchModel newRepository: self entity: each ]
]

{ #category : 'accessing' }
DockRepositoryModel >> location [

	^ self entity location
]

{ #category : 'private' }
DockRepositoryModel >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'accessing' }
DockRepositoryModel >> name [

	^ self entity name
]

{ #category : 'testing' }
DockRepositoryModel >> needsRepair [

	^ self isMissing or: [ self isDetached ]
]

{ #category : 'actions - command' }
DockRepositoryModel >> newCommitAction [

	^ IceTipCommitAction new
		workingCopy: self entity workingCopy;
		repository: self entity workingCopy repository;
		diff: self diffToReferenceCommit;
		items: self activeNodes;
		yourself
]

{ #category : 'actions - command' }
DockRepositoryModel >> newFetchAction [
	
	^ IceTipStandardAction new
		repository: self entity;
		action: [ self entity fetch ];
		yourself
]

{ #category : 'actions - command' }
DockRepositoryModel >> newPushAction [

	^ IceTipStandardAction new 
		repository: self entity;
		message: ('Pushing to {1}' format: { self entity branch name }) ;
		action: [ self entity pushTo: self remoteToPush ];
		yourself
]

{ #category : 'actions - command' }
DockRepositoryModel >> newPushActionTo: aRemote [

	^ IceTipStandardAction new 
		repository: self entity;
		message: ('Pushing to {1}' format: { self entity branch name }) ;
		action: [ self entity pushTo: (aRemote ifNil: [ self entity branch upstream remote ]) ];
		yourself
]

{ #category : 'accessing' }
DockRepositoryModel >> outgoingCommits [

	(self entity isValid and: [ self entity canPush ]) ifFalse: [ ^ #() ].

	^ self critical: [ 
		self entity branch 
			ifNotNil: [ : aBranch | aBranch outgoingCommits ]
			ifNil: [ #() ] ]
]

{ #category : 'accessing' }
DockRepositoryModel >> packages [

	^ self entity workingCopy packages
		collect: [ :each | DockRepositoryPackageModel newRepository: self entity: each ]
]

{ #category : 'accessing' }
DockRepositoryModel >> remoteBranches [
	| branches |

	self entity isValid ifFalse: [ ^ #() ].

	branches := self critical: [ self entity remoteTrackedBranches ].
	^ branches collect: [ :each | 
		DockRepositoryRemoteBranchModel newRepository: self entity: each ]
]

{ #category : 'private' }
DockRepositoryModel >> remoteToPush [
	| head |

	head := self entity head.
	^ head upstream remote
]

{ #category : 'accessing' }
DockRepositoryModel >> remotes [

	self flag: #TODO. "This needs to be a model"
	^ self entity remotes
]

{ #category : 'accessing' }
DockRepositoryModel >> repairActions [

	^ DockRepositoryRepairAction allAvailableFor: self entity
]

{ #category : 'accessing' }
DockRepositoryModel >> repositoryLocation [

	^ self entity location
]

{ #category : 'accessing' }
DockRepositoryModel >> resetDiff [

	diff := nil.
	diffNode := nil
]

{ #category : 'actions' }
DockRepositoryModel >> setUpstream: aRemote [ 

	self entity branch setUpstreamIfMissing: aRemote
]

{ #category : 'accessing' }
DockRepositoryModel >> status [
	
	[
		self isMissing 						ifTrue: [ ^ #missing ].
		self isDetached 						ifTrue: [ ^ #detached ].
		self entity loadedPackages isEmpty 	ifTrue: [ ^ #notLoaded ].
		self entity 	workingCopy isModified 	ifTrue: [ ^ #modified ].
		^ #upToDate ]
	on: Error 
	do: [ :e | 
		logger error: e.
		^ #error ]
]

{ #category : 'actions' }
DockRepositoryModel >> switchToBranchNamed: branchName [

	self entity
		ensureBranch: branchName;
		switchToBranchNamed: branchName
]

{ #category : 'accessing' }
DockRepositoryModel >> tags [

	self entity isValid ifFalse: [ ^ #() ].

	^ self entity tags collect: [ :each | 
		DockRepositoryTagModel newRepository: self entity: each ]
]
