Class {
	#name : 'PulsarRepositoryModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'diff',
		'diffNode',
		'mutex',
		'registeredStatus'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'private' }
PulsarRepositoryModel >> activeNodes [

	^ Array streamContents: [ :stream | 
		self diffNode withAllChildrenDo: [ :each | 
			each isActive 
				ifTrue: [ stream nextPut: each node ] ] ]
]

{ #category : 'actions' }
PulsarRepositoryModel >> addPackage: aPackage [

	self entity workingCopy addPackageNamed: aPackage name
]

{ #category : 'accessing' }
PulsarRepositoryModel >> allPackagesAvailableToAdd [
	| packageNames |
	
	packageNames := self entity workingCopy packages collect: #name.
	^ self environmentModel allPackages 
		reject: [ :each  | packageNames includes: each name ]
]

{ #category : 'private' }
PulsarRepositoryModel >> basicStatus [
	
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

{ #category : 'accessing' }
PulsarRepositoryModel >> calculateDiffToHead [

	^ self critical: [ 
		self entity workingCopy diffTo: self entity headCommit ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> calculateDiffToReferenceCommit [

	^ self critical: [ 
		self entity workingCopy diffToReferenceCommit ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> commitsTo: aNumber [

	self entity isValid ifFalse: [ ^ #() ].

	^ Array new: aNumber streamContents: [ :stream | 
		| count |
		count := 0.
		self critical: [
			self entity branch commitsDo: [ :aCommit | 
				count < aNumber ifTrue: [ 
					stream nextPut: (PulsarRepositoryCommitModel 
						newRepository: self 
						entity: aCommit).
					count := count + 1 ] ] ] ]
]

{ #category : 'private' }
PulsarRepositoryModel >> critical: aBlock [

	^ self mutex critical: aBlock
]

{ #category : 'accessing' }
PulsarRepositoryModel >> diffNode [

	self entity isValid ifFalse: [ ^ PulsarDiffNode newRepository: self entity: IceNode new ].

	^ diffNode ifNil: [ 
		diffNode := PulsarDiffNode 
			newRepository: self
			entity: self diffToReferenceCommit tree ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> diffToReferenceCommit [

	^ diff ifNil: [ 
		diff := self calculateDiffToReferenceCommit ]
]

{ #category : 'actions' }
PulsarRepositoryModel >> discardChangesOn: aNode [

	self entity workingCopy discardChanges: aNode entity.
	self resetDiff
]

{ #category : 'testing' }
PulsarRepositoryModel >> hasUpstream [

	^ self entity branch hasUpstream
]

{ #category : 'accessing' }
PulsarRepositoryModel >> headName [

	^ self critical: [ self entity head name ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> incomingCommits [

	(self entity isValid and: [ self entity canPush ]) ifFalse: [ ^ #() ].

	^ self critical: [  
		self entity branch 
			ifNotNil: [ :aBranch | aBranch incomingCommits ]
			ifNil: [ #() ] ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isDetached [

	^ self entity workingCopy isDetached 
		or: [ self entity head isDetached ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isHeadInBranch [

	^ self critical: [ self entity head isBranch ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isMissing [

	^ self entity isMissing
]

{ #category : 'testing' }
PulsarRepositoryModel >> isOutgoingCommit: aCommitModel [

	self entity isValid ifFalse: [ ^ false ].

	self entity outgoingCommits ifNotEmpty: [ :aCollection | 
		^ aCollection anySatisfy: [ :each |
			each id = aCommitModel commit id ] ].

	^ false
]

{ #category : 'testing' }
PulsarRepositoryModel >> isPackageLoaded: aPackageModel [

	^ self entity workingCopy isLoadedPackageNamed: aPackageModel name
]

{ #category : 'testing' }
PulsarRepositoryModel >> isSystemRepository [

	^ self entity project tags includes: #system
]

{ #category : 'accessing' }
PulsarRepositoryModel >> localBranches [
	| branches |

	self entity isValid ifFalse: [ ^ #() ].

	branches := self critical: [ self entity localBranches ].
	^ branches collect: [ :each | 
		PulsarRepositoryLocalBranchModel newRepository: self entity: each ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> location [

	^ self entity location
]

{ #category : 'private' }
PulsarRepositoryModel >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> name [

	^ self entity name
]

{ #category : 'testing' }
PulsarRepositoryModel >> needsRepair [

	^ self isMissing or: [ self isDetached ]
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newCommitAction [

	^ IceTipCommitAction new
		workingCopy: self entity workingCopy;
		repository: self entity workingCopy repository;
		diff: self diffToReferenceCommit;
		items: self activeNodes;
		yourself
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newFetchAction [
	
	^ IceTipStandardAction new
		repository: self entity;
		action: [ self entity fetch ];
		yourself
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newPushAction [

	^ IceTipStandardAction new 
		repository: self entity;
		message: ('Pushing to {1}' format: { self entity branch name }) ;
		action: [ self entity pushTo: self remoteToPush ];
		yourself
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newPushActionTo: aRemote [

	^ IceTipStandardAction new 
		repository: self entity;
		message: ('Pushing to {1}' format: { self entity branch name }) ;
		action: [ self entity pushTo: (aRemote ifNil: [ self entity branch upstream remote ]) ];
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryModel >> outgoingCommits [

	(self entity isValid and: [ self entity canPush ]) ifFalse: [ ^ #() ].

	^ self critical: [ 
		self entity branch 
			ifNotNil: [ : aBranch | aBranch outgoingCommits ]
			ifNil: [ #() ] ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> packages [

	^ self entity workingCopy packages
		collect: [ :each | PulsarRepositoryPackageModel newRepository: self entity: each ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> project [

	^ self entity project
]

{ #category : 'actions' }
PulsarRepositoryModel >> recalculateDirtyChanges [

	self entity workingCopy forceCalculateDirtyPackages.
	self resetDiff
]

{ #category : 'testing' }
PulsarRepositoryModel >> registeredStatusChanged [

	^ registeredStatus ~= self basicStatus
]

{ #category : 'accessing' }
PulsarRepositoryModel >> remoteBranches [
	| branches |

	self entity isValid ifFalse: [ ^ #() ].

	branches := self critical: [ self entity remoteTrackedBranches ].
	^ branches collect: [ :each | 
		PulsarRepositoryRemoteBranchModel newRepository: self entity: each ]
]

{ #category : 'private' }
PulsarRepositoryModel >> remoteToPush [
	| head |

	head := self entity head.
	^ head upstream remote
]

{ #category : 'accessing' }
PulsarRepositoryModel >> remotes [

	self flag: #TODO. "This needs to be a model"
	^ self entity remotes
]

{ #category : 'accessing' }
PulsarRepositoryModel >> repairActions [

	^ (PulsarRepositoryRepairAction allAvailableFor: self entity)
		do: [ :each | each repositoryModel: self ];
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryModel >> repositoryLocation [

	^ self entity location
]

{ #category : 'accessing' }
PulsarRepositoryModel >> resetDiff [

	diff := nil.
	diffNode := nil
]

{ #category : 'actions' }
PulsarRepositoryModel >> setUpstream: aRemote [ 

	self entity branch setUpstreamIfMissing: aRemote
]

{ #category : 'accessing' }
PulsarRepositoryModel >> status [

	"I update status each time I ask because I need to know it to see if this changed in 
	 #registeredStatusChanged. This is an optimisation to not trigger an update of the UI 
	 each time (most of the times is not needed)"
	^ registeredStatus := self basicStatus
]

{ #category : 'actions' }
PulsarRepositoryModel >> switchToBranchNamed: branchName [

	self entity
		ensureBranch: branchName;
		switchToBranchNamed: branchName
]

{ #category : 'accessing' }
PulsarRepositoryModel >> tags [

	self entity isValid ifFalse: [ ^ #() ].

	^ self entity tags collect: [ :each | 
		PulsarRepositoryTagModel newRepository: self entity: each ]
]
