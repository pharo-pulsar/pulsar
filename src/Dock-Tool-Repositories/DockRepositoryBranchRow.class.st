Class {
	#name : 'DockRepositoryBranchRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'extraPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'initialization' }
DockRepositoryBranchRow >> addIncomingCommits: incomingCommits [

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
DockRepositoryBranchRow >> addOutgoingCommits: outgoingCommits [

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
DockRepositoryBranchRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: namePresenter expand: false;
		add: extraPresenter;
		yourself
]

{ #category : 'initialization' }
DockRepositoryBranchRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockRepositoryBranchRow'.

	namePresenter := self newLabel.
	extraPresenter := self newPresenter
		addStyle: 'extra';
		layout: (SpBoxLayout newHorizontal
			hAlignStart;
			yourself);
		yourself
]

{ #category : 'initialization' }
DockRepositoryBranchRow >> updatePresenter [

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
