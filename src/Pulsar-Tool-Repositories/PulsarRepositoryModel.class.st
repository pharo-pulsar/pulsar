Class {
	#name : 'PulsarRepositoryModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'diff',
		'diffNode',
		'mutex',
		'registeredStatus',
		'outgoingCommits',
		'incomingCommits'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'testing' }
PulsarRepositoryModel >> acceptsRepair [
	"indicates whenever the repository can accept a repair action regardless if 
	 it can be opened (you can open some 'broken' repositories)"

	^ self isMissing 
		or: [ self isDetached  ]
]

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

{ #category : 'actions' }
PulsarRepositoryModel >> addRemote: aName url: anUrl [

	self entity addRemote: (IceGitRemote name: aName url: anUrl)
]

{ #category : 'accessing' }
PulsarRepositoryModel >> allPackagesAvailableToAdd [
	| packageNames |
	
	packageNames := self entity workingCopy packages collect: #name.
	^ self environmentModel allPackages 
		reject: [ :each  | packageNames includes: each name ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> baselines [

	^ self packages 
		select: [ :each | each isBaseline ]
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

{ #category : 'private' }
PulsarRepositoryModel >> branchOrTag [

	^ [ self entity branch ]
	on: IceNotInBranch 
	do: [ :e | 
		self entity head tags
			ifNotEmpty: [ :aCollection | aCollection first ]
			ifEmpty: [ e pass ] ]
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

{ #category : 'testing' }
PulsarRepositoryModel >> canCommit [
	"indicates whenever the repository can commit"

	^ self isMissing not 
		and: [ self isDetached not ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> checkoutStrategies [

	^ IceCheckoutStrategy allStrategies
]

{ #category : 'accessing' }
PulsarRepositoryModel >> commitsUpTo: aNumber inBranch: aRepositoryBranchModel [
	| branch |

	self entity isValid ifFalse: [ ^ #() ].

	branch := aRepositoryBranchModel 
		ifNotNil: [ :aModel | aModel entity ]
		ifNil: [ self branchOrTag ].

	^ Array new: aNumber streamContents: [ :stream | 
		self critical: [
			branch withCommitWalkDo: [ :walk |
		  		walk
			  		maxNumber: aNumber;
			  		commitsDo: [ :aCommit | 
						stream nextPut: (PulsarRepositoryCommitModel 
							newRepository: self 
							entity: aCommit) ] ] ] ]
]

{ #category : 'private' }
PulsarRepositoryModel >> critical: aBlock [

	^ self mutex critical: aBlock
]

{ #category : 'accessing' }
PulsarRepositoryModel >> diffNode [

	self entity isValid ifFalse: [ ^ PulsarDiffNode newRepository: self entity: IceNode new ].

	^ diffNode ifNil: [ 
		diffNode := PulsarDiffRoot
			newRepository: self
			from: self entity workingCopy referenceCommit 
			to: self entity workingCopy
			tree: self diffToReferenceCommit tree ]
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

{ #category : 'actions - command' }
PulsarRepositoryModel >> forgetAction [

	^ IceTipStandardAction new
		repository: self entity;
		message: ('Forgeting {1}' format: { self name });
		action: [ self entity forget ];
		yourself
]

{ #category : 'testing' }
PulsarRepositoryModel >> hasPendingRemoteOperation [

	self entity isValid ifFalse: [ ^ false ].
	self entity head isBranch ifFalse: [ ^ false ]. 

	^ self outgoingCommits isNotEmpty or: [ self incomingCommits isNotEmpty ]
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
PulsarRepositoryModel >> headTags [

	self entity isValid ifFalse: [ ^ #() ].

	^ self entity head tags collect: [ :each | 
		PulsarRepositoryTagModel newRepository: self entity: each ]
]

{ #category : 'accessing' }
PulsarRepositoryModel >> incomingCommits [

	(self entity isValid and: [ self entity canPush ]) ifFalse: [ ^ #() ].

	^ self critical: [  
		incomingCommits ifNil: [ 
			incomingCommits := self entity branch 
				ifNotNil: [ :aBranch | aBranch incomingCommits ]
				ifNil: [ #() ] ] ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isDetached [

	^ self entity workingCopy isDetached 
		or: [ self entity head isDetached ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isDirty [

	^ self isMissing not 
		and: [ self entity workingCopy isModified ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isHeadInBranch [

	^ self critical: [ self entity head isBranch ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isHeadInTag [

	^ self critical: [ self entity head tags isNotEmpty ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isLocked [
	| baselines |
	
	baselines := self baselines.
	baselines ifEmpty: [ ^ false ].

	^ baselines allSatisfy: [ :each | each isBaselineLocked ]
]

{ #category : 'testing' }
PulsarRepositoryModel >> isMissing [

	^ self entity isMissing
]

{ #category : 'testing' }
PulsarRepositoryModel >> isOutgoingCommit: aCommitModel [

	self entity isValid ifFalse: [ ^ false ].
	self entity head isBranch ifFalse: [ ^ false ]. 

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
PulsarRepositoryModel >> isRemoteUpstream: aRemote [
	
	self isHeadInBranch ifFalse: [ ^ false ].
	self entity branch hasUpstream ifFalse: [ ^ false ].
	
	^ self entity branch upstream remote = aRemote
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

{ #category : 'accessing' }
PulsarRepositoryModel >> lockIconName [

	^ self isLocked 
		ifTrue: [ 'lock' ]
		ifFalse: [ 'unlock' ]
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
	"indicates whenever the repository REQUIRES a repair action (it cannot be opened at all)"

	^ self isMissing 
		or: [ 
			self isDetached 
			and: [ self isHeadInBranch not
			and: [ self isHeadInTag not ] ] ]
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newCheckoutActionWithStrategy: aCheckoutStrategy [
	
	^ IceTipStandardAction new 
		repository: self entity;
		onSuccessRepositoryModified;
		action: [ 
			aCheckoutStrategy committish: self entity head.
			aCheckoutStrategy diff: self diffNode entity.
			self entity checkout: aCheckoutStrategy ];
		yourself
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
PulsarRepositoryModel >> newPullActionFrom: aRemote [
	| remote |

	remote := aRemote ifNil: [ self entity branch upstream remote ].
	^ IceTipStandardAction new 
		repository: self entity;
		message: ('Pulling from {1}' format: { remote name });
		action: [ self entity pullFrom: remote ];
		yourself
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newPushAction [

	^ IceTipStandardAction new 
		repository: self entity;
		message: ('Pushing to {1}' format: { self entity branch name }) ;
		action: [ 
			self entity pushTo: self remoteToPush.
			self resetDiff ];
		yourself
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newPushActionTo: aRemote [

	^ IceTipStandardAction new 
		repository: self entity;
		message: ('Pushing to {1}' format: { self entity branch name }) ;
		action: [
			| upstream remote |
			
			upstream := self entity branch upstreamIfNone: [ nil ].
			remote := upstream ifNotNil: [ upstream remote ].
			"if this is not the default branch, se it (for the future). 
			 This is maybe wrong in certain cases, but I think most of the cases is a good choice. 
			 And we follow the criteria 'make 90% of cases easy while make possible the other 10%'"
			(aRemote isNotNil and: [ aRemote ~= remote]) 
				ifTrue: [ remote := aRemote ].
			self entity pushTo: remote.
			self entity branch setUpstreamRemote: remote.
			self resetDiff ];
		yourself
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newRecalculateDirtyPackagesAction [

	^ IceTipStandardAction new
		repository: self entity;
		message: 'Recalculating The Dirty Package';
		onSuccessRepositoryModified;
		action: [ self entity workingCopy forceCalculateDirtyPackages ];
		yourself
]

{ #category : 'actions - command' }
PulsarRepositoryModel >> newRemoveRemoteActionFor: aRemote [
	
	^ IceTipStandardAction new
		repository: self entity;
		message: ('Removing remote {1}' format: { aRemote name });
		onSuccessRepositoryModified;
		action: [ self entity removeRemote: aRemote ];
		yourself
]

{ #category : 'accessing' }
PulsarRepositoryModel >> outgoingCommits [

	(self entity isValid and: [ self entity canPush ]) ifFalse: [ ^ #() ].

	^ self critical: [ 
		outgoingCommits ifNil: [ 
			outgoingCommits := self entity branch 
				ifNotNil: [ : aBranch | aBranch outgoingCommits ]
				ifNil: [ #() ] ] ]
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
	diffNode := nil.
	outgoingCommits := nil.
	incomingCommits := nil
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

{ #category : 'actions' }
PulsarRepositoryModel >> toggleLock [
	| currentLock |

	currentLock := self isLocked.
	self baselines 
		do: [ :each | each lockBaseline: currentLock not ]
]

{ #category : 'actions' }
PulsarRepositoryModel >> updateLocation: aReference [
	
	"change location"
	self entity location: aReference.
	self entity postFetch
]
