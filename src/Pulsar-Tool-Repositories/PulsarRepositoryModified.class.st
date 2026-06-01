Class {
	#name : 'PulsarRepositoryModified',
	#superclass : 'PulsarAnnouncement',
	#instVars : [
		'reason'
	],
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'instance creation' }
PulsarRepositoryModified class >> branchCreated: aModel [

	^ (self newValue: aModel)
		  reason: PulsarRepositoryModifiedReason branchCreated;
		  yourself
]

{ #category : 'instance creation' }
PulsarRepositoryModified class >> checkout: aModel [

	^ (self newValue: aModel)
		  reason: PulsarRepositoryModifiedReason checkout;
		  yourself
]

{ #category : 'instance creation' }
PulsarRepositoryModified class >> commit: aModel [

	^ (self newValue: aModel)
		  reason: PulsarRepositoryModifiedReason commit;
		  yourself
]

{ #category : 'instance creation' }
PulsarRepositoryModified class >> fetch: aModel [

	^ (self newValue: aModel)
		  reason: PulsarRepositoryModifiedReason fetch;
		  yourself
]

{ #category : 'instance creation' }
PulsarRepositoryModified class >> merge: aModel [

	^ (self newValue: aModel)
		  reason: PulsarRepositoryModifiedReason merge;
		  yourself
]

{ #category : 'instance creation' }
PulsarRepositoryModified class >> newValue: aModel reason: aReason [

	^ (self newValue: aModel)
		  reason: aReason;
		  yourself
]

{ #category : 'instance creation' }
PulsarRepositoryModified class >> pull: aModel [

	^ (self newValue: aModel)
		  reason: PulsarRepositoryModifiedReason pull;
		  yourself
]

{ #category : 'instance creation' }
PulsarRepositoryModified class >> push: aModel [

	^ (self newValue: aModel)
		  reason: PulsarRepositoryModifiedReason push;
		  yourself
]

{ #category : 'instance creation' }
PulsarRepositoryModified class >> repair: aModel [

	^ (self newValue: aModel)
		  reason: PulsarRepositoryModifiedReason repair;
		  yourself
]

{ #category : 'query' }
PulsarRepositoryModified >> affectsBranches [

	^ self reason affectsBranches
]

{ #category : 'query' }
PulsarRepositoryModified >> affectsChanges [

	^ self reason affectsChanges
]

{ #category : 'query' }
PulsarRepositoryModified >> affectsCommits [

	^ self reason affectsCommits
]

{ #category : 'query' }
PulsarRepositoryModified >> affectsRemoteBranches [

	^ self reason affectsRemoteBranches
]

{ #category : 'query' }
PulsarRepositoryModified >> affectsRepositoryList [

	^ self reason affectsRepositoryList
]

{ #category : 'query' }
PulsarRepositoryModified >> affectsTags [

	^ self reason affectsTags
]

{ #category : 'accessing' }
PulsarRepositoryModified >> reason [

	^ reason ifNil: [ reason := PulsarRepositoryModifiedReason anything ]
]

{ #category : 'accessing' }
PulsarRepositoryModified >> reason: aReason [

	reason := aReason
]
