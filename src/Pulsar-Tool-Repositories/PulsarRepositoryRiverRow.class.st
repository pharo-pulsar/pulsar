Class {
	#name : 'PulsarRepositoryRiverRow',
	#superclass : 'GitRiverLayoutRowPresenter',
	#instVars : [
		'summaryPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Commit',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Commit'
}

{ #category : 'layout' }
PulsarRepositoryRiverRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: graphPresenter expand: false;
		add: summaryPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRiverRow >> initializePresenters [

	super initializePresenters.
	summaryPresenter := self newLabel
		addStyle: 'gitRiverSummary';
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRiverRow >> updatePresenter [

	super updatePresenter.
	
	self model ifNil: [ ^ self ].
	
	summaryPresenter label: self model shortCommitMessage capitalized
]
