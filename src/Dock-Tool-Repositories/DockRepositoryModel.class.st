Class {
	#name : 'DockRepositoryModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'diff',
		'diffNode'
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
		self entity branch commitsDo: [ :aCommit | 
			count < aNumber ifTrue: [ 
				stream nextPut: (DockRepositoryCommitModel 
					newRepository: self 
					entity: aCommit).
				count := count + 1 ] ] ]
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
		diff := self entity workingCopy diffToReferenceCommit ]
]

{ #category : 'accessing' }
DockRepositoryModel >> incomingCommits [

	(self entity isValid and: [ self entity canPush ]) ifFalse: [ ^ #() ].

	^ self entity branch 
		ifNotNil: [ :aBranch | aBranch incomingCommits ]
		ifNil: [ #() ]
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

	self entity isValid ifFalse: [ ^ #() ].

	^ self entity localBranches collect: [ :each | 
		DockRepositoryLocalBranchModel newRepository: self entity: each ]
]

{ #category : 'accessing' }
DockRepositoryModel >> location [

	^ self entity location
]

{ #category : 'accessing' }
DockRepositoryModel >> name [

	^ self entity name
]

{ #category : 'instance creation' }
DockRepositoryModel >> newCommitAction [

	^ IceTipCommitAction new
		workingCopy: self entity workingCopy;
		repository: self entity workingCopy repository;
		diff: self diffToReferenceCommit;
		items: self activeNodes;
		yourself
]

{ #category : 'instance creation' }
DockRepositoryModel >> newFetchAction [
	
	^ IceTipStandardAction new
		repository: self entity;
		action: [ self entity fetch ];
		yourself
]

{ #category : 'instance creation' }
DockRepositoryModel >> newPushAction [

	^ IceTipStandardAction new 
		repository: self entity;
		message: ('Pushing to {1}' format: { self entity branch name }) ;
		action: [ self entity push ];
		yourself
]

{ #category : 'accessing' }
DockRepositoryModel >> outgoingCommits [

	(self entity isValid and: [ self entity canPush ]) ifFalse: [ ^ #() ].

	^ self entity branch 
		ifNotNil: [ : aBranch | aBranch outgoingCommits ]
		ifNil: [ #() ]
]

{ #category : 'accessing' }
DockRepositoryModel >> packages [

	^ self entity workingCopy packages
		collect: [ :each | DockRepositoryPackageModel newRepository: self entity: each ]
]

{ #category : 'accessing' }
DockRepositoryModel >> remoteBranches [

	self entity isValid ifFalse: [ ^ #() ].

	^ self entity remoteTrackedBranches collect: [ :each | 
		DockRepositoryRemoteBranchModel newRepository: self entity: each ]
]

{ #category : 'accessing' }
DockRepositoryModel >> resetDiff [

	diff := nil.
	diffNode := nil
]

{ #category : 'accessing' }
DockRepositoryModel >> status [
	
	[
		self entity isMissing 				ifTrue: [ ^ #missing ].
		self entity loadedPackages isEmpty 	ifTrue: [ ^ #notLoaded ].
		self entity 	workingCopy isModified 	ifTrue: [ ^ #modified ].
		^ #upToDate ]
	on: Error 
	do: [ :e | 
		logger error: e.
		^ #error ]
]

{ #category : 'accessing' }
DockRepositoryModel >> tags [

	self entity isValid ifFalse: [ ^ #() ].

	^ self entity tags collect: [ :each | 
		DockRepositoryTagModel newRepository: self entity: each ]
]
