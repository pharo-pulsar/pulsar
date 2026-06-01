"
Abstract reason category for PulsarRepositoryModified announcements. Each concrete subclass represents a Git operation and answers which repository aspects it affects via affectsChanges, affectsCommits, affectsBranches, affectsTags, and affectsRepositoryList.
"
Class {
	#name : 'PulsarRepositoryModifiedReason',
	#superclass : 'Object',
	#classVars : [
		'ReasonAnything',
		'ReasonBranchCreated',
		'ReasonCheckout',
		'ReasonCommit',
		'ReasonFetch',
		'ReasonMerge',
		'ReasonPull',
		'ReasonPush',
		'ReasonRepair'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> anything [

	^ ReasonAnything ifNil: [ ReasonAnything := PulsarRepositoryModifiedAnythingReason new ]
]

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> branchCreated [

	^ ReasonBranchCreated ifNil: [ ReasonBranchCreated := PulsarRepositoryModifiedBranchCreatedReason new ]
]

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> checkout [

	^ ReasonCheckout ifNil: [ ReasonCheckout := PulsarRepositoryModifiedCheckoutReason new ]
]

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> commit [

	^ ReasonCommit ifNil: [ ReasonCommit := PulsarRepositoryModifiedCommitReason new ]
]

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> fetch [

	^ ReasonFetch ifNil: [ ReasonFetch := PulsarRepositoryModifiedFetchReason new ]
]

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> merge [

	^ ReasonMerge ifNil: [ ReasonMerge := PulsarRepositoryModifiedMergeReason new ]
]

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> pull [

	^ ReasonPull ifNil: [ ReasonPull := PulsarRepositoryModifiedPullReason new ]
]

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> push [

	^ ReasonPush ifNil: [ ReasonPush := PulsarRepositoryModifiedPushReason new ]
]

{ #category : 'instance creation' }
PulsarRepositoryModifiedReason class >> repair [

	^ ReasonRepair ifNil: [ ReasonRepair := PulsarRepositoryModifiedRepairReason new ]
]

{ #category : 'query' }
PulsarRepositoryModifiedReason >> affectsBranches [

	^ self subclassResponsibility
]

{ #category : 'query' }
PulsarRepositoryModifiedReason >> affectsChanges [

	^ self subclassResponsibility
]

{ #category : 'query' }
PulsarRepositoryModifiedReason >> affectsCommits [

	^ self subclassResponsibility
]

{ #category : 'query' }
PulsarRepositoryModifiedReason >> affectsRemoteBranches [

	^ self subclassResponsibility
]

{ #category : 'query' }
PulsarRepositoryModifiedReason >> affectsRepositoryList [

	^ self subclassResponsibility
]

{ #category : 'query' }
PulsarRepositoryModifiedReason >> affectsTags [

	^ self subclassResponsibility
]
