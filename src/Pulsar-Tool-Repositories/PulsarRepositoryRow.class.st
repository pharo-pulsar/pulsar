Class {
	#name : 'PulsarRepositoryRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'labelPresenter',
		'extraPresenter'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'initialization' }
PulsarRepositoryRow >> addIncomingCommits: incomingCommits [

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
PulsarRepositoryRow >> addOutgoingCommits: outgoingCommits [

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
PulsarRepositoryRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: labelPresenter expand: false;
		add: extraPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockRepositoryRow'.
	
	labelPresenter := self newLabel.
	extraPresenter := self newPresenter
		addStyle: 'extra';
		layout: (SpBoxLayout newHorizontal
			hAlignStart;
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	labelPresenter label: self model name.
	labelPresenter removeAllStyles.
	labelPresenter addStyle: self model status asString.
	
	extraPresenter layout removeAll.
	self model outgoingCommits
		ifNotEmpty: [ :outgoingCommits | self addOutgoingCommits: outgoingCommits ].
	self model incomingCommits
		ifNotEmpty: [ :incomingCommits | self addIncomingCommits: incomingCommits ].

]
