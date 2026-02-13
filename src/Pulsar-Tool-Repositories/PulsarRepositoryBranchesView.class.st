Class {
	#name : 'PulsarRepositoryBranchesView',
	#superclass : 'PulsarBaseView',
	#instVars : [
		'toolbarPresenter',
		'localPresenter',
		'remotePresenter',
		'tagPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Branches'
}

{ #category : 'defaults' }
PulsarRepositoryBranchesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 2;
		yourself
]

{ #category : 'layout' }
PulsarRepositoryBranchesView >> defaultLayout [

	^ SpTabLayout new
		add: localPresenter label: 'Local';
		add: remotePresenter label: 'Remote';
		add: tagPresenter label: 'Tags';
		yourself
]

{ #category : 'events' }
PulsarRepositoryBranchesView >> eventRepositoryModified: ann [

	ann value = self model ifFalse: [ ^ self ].
	
	{ localPresenter. remotePresenter. tagPresenter } 
		do: [ :each | each updatePresenter ]
]

{ #category : 'initialization' }
PulsarRepositoryBranchesView >> initializePresenters [

	localPresenter := self instantiate: PulsarRepositoryLocalBranchView on: self model.
	remotePresenter := self instantiate: PulsarRepositoryRemoteBranchView on: self model.
	tagPresenter := self instantiate: PulsarRepositoryTagBranchView on: self model
]

{ #category : 'initialization' }
PulsarRepositoryBranchesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Branches'
]

{ #category : 'accessing - model' }
PulsarRepositoryBranchesView >> model: aModel [ 

	super model: aModel.
	localPresenter model: aModel.
	remotePresenter model: aModel.
	tagPresenter model: aModel
]

{ #category : 'initialization' }
PulsarRepositoryBranchesView >> registerToEvents [

	super registerToEvents.
	
	self announcer 
		when: PulsarRepositoryModified
		send: #eventRepositoryModified:
		to: self
]

{ #category : 'initialization' }
PulsarRepositoryBranchesView >> updatePresenter [

	
]
