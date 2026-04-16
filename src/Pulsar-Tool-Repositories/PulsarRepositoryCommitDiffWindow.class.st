Class {
	#name : 'PulsarRepositoryCommitDiffWindow',
	#superclass : 'PulsarBaseWindow',
	#traits : 'PulsarTSnapshot',
	#classTraits : 'PulsarTSnapshot classTrait',
	#instVars : [
		'diffPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View'
}

{ #category : 'layout' }
PulsarRepositoryCommitDiffWindow >> defaultLayout [

	^ SpBoxLayout newVertical
		add: diffPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryCommitDiffWindow >> initializePresenters [

	self addStyle: 'pulsarRepositoryCommitDiffWindow'.

	diffPresenter := self instantiate: PulsarRepositoryDiffPresenter
]

{ #category : 'initialization' }
PulsarRepositoryCommitDiffWindow >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: (self model ifNotNil: #fullName ifNil: [ 'Diff' ])
]

{ #category : 'private' }
PulsarRepositoryCommitDiffWindow >> notifyRepositoryModified: aModel [
	| announcementModel |

	announcementModel := (aModel respondsTo: #repositoryModel)
		ifTrue: [ aModel repositoryModel ]
		ifFalse: [ aModel ].

	logger trace: announcementModel.

	self application resendAnnouncement: (PulsarRepositoryModified newValue: announcementModel)
]

{ #category : 'accessing - snapshot' }
PulsarRepositoryCommitDiffWindow >> snapshot [

	^ PulsarPresenterWithModelSnapshot on: self
]

{ #category : 'initialization' }
PulsarRepositoryCommitDiffWindow >> updatePresenter [

	self model ifNil: [ ^ self ].

	diffPresenter model: self model
]
