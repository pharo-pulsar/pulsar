Class {
	#name : 'DockRepositoryBaseBranchView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'private' }
DockRepositoryBaseBranchView >> branches [

	self subclassResponsibility
]

{ #category : 'layout' }
DockRepositoryBaseBranchView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
DockRepositoryBaseBranchView >> initializePresenters [

	self addStyle: 'dockRepositoryBranch'.

	toolbarPresenter := self instantiate: DockToolbarPresenter. 
	toolbarPresenter actions: (self actions actionsFor: #gitActions).

	listPresenter := self newEasyListView
		addStyle: 'stList';
		rowPresenterClass: DockRepositoryBranchRow;
		display: [ :aBranchModel | aBranchModel name ];
		yourself
]

{ #category : 'private' }
DockRepositoryBaseBranchView >> maybeSort: aCollection [

	^ aCollection
]

{ #category : 'initialization' }
DockRepositoryBaseBranchView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self withWindowDo: #jobStart.
	self application schedule: [ 
		| branches |
		[ 
			branches := self maybeSort: self branches.
			self application defer: [ 
				listPresenter items: branches] ] 
		ensure: [ self withWindowDo: #jobEnd ] ]
]
