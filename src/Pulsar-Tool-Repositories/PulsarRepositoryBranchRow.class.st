Class {
	#name : 'PulsarRepositoryBranchRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'extraPresenter'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'initialization' }
PulsarRepositoryBranchRow >> addIncomingCommits: incomingCommits [

	extraPresenter layout 
		add: (self newImage
			image: (self iconNamed: 'arrowDown');
			yourself);
		add: (self newLabel 
			addStyle: 'incoming';
			label: incomingCommits size asString;
			yourself)
]

{ #category : 'initialization' }
PulsarRepositoryBranchRow >> addOutgoingCommits: outgoingCommits [

	extraPresenter layout 
		add: (self newImage
			image: (self iconNamed: 'arrowUp');
			yourself);
		add: (self newLabel 
			addStyle: 'outgoing';
			label: outgoingCommits size asString;
			yourself)
]

{ #category : 'layout' }
PulsarRepositoryBranchRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: namePresenter expand: false;
		add: extraPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryBranchRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarRepositoryBranchRow'.

	namePresenter := self newLabel.
	extraPresenter := self newPresenter
		addStyle: 'extra';
		layout: (SpBoxLayout newHorizontal
			hAlignStart;
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryBranchRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter label: self model name.
	namePresenter removeAllStyles.
	self model isHead
		ifTrue: [ namePresenter addStyle: 'head' ].
		
	extraPresenter layout removeAll.
	self model outgoingCommits 
		ifNotEmpty: [ :outgoingCommits | self addOutgoingCommits: outgoingCommits ].
	self model incomingCommits 
		ifNotEmpty: [ :incomingCommits | self addIncomingCommits: incomingCommits ]
]
