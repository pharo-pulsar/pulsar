Class {
	#name : 'PulsarRepositoryMergeWindow',
	#superclass : 'PulsarBaseWindow',
	#instVars : [
		'diffPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View'
}

{ #category : 'layout' }
PulsarRepositoryMergeWindow >> defaultLayout [

	^ SpBoxLayout newVertical
		add: diffPresenter;
		yourself
]

{ #category : 'actions' }
PulsarRepositoryMergeWindow >> doMerge [

	self scheduleJob: [
		self model newMergeAction
			onSuccess: [
				self notifyRepositoryModified: self model.
				self withWindowDo: #close ];
			executeWithContext: self ]
]

{ #category : 'initialization' }
PulsarRepositoryMergeWindow >> initializePresenters [
	self addStyle: 'pulsarRepositoryRepairWindow'.
	self addStyle: 'pulsarRepositoryMerge'.

	diffPresenter := self instantiate: PulsarRepositoryDiffPresenter
]

{ #category : 'initialization' }
PulsarRepositoryMergeWindow >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'Merge';
		addControl: (self newButton
			label: 'Merge';
			icon: (self iconNamed: 'merge');
			action: [ self doMerge ];
			yourself)
]

{ #category : 'private' }
PulsarRepositoryMergeWindow >> notifyRepositoryModified: aModel [
	| announcementModel |

	announcementModel := (aModel respondsTo: #repositoryModel)
		ifTrue: [ aModel repositoryModel ]
		ifFalse: [ aModel ].

	logger trace: announcementModel.

	self application resendAnnouncement: (PulsarRepositoryModified newValue: announcementModel)
]

{ #category : 'initialization' }
PulsarRepositoryMergeWindow >> updatePresenter [

	self model ifNil: [ ^ self ].

	diffPresenter model: self model
]
