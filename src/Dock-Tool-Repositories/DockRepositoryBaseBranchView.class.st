Class {
	#name : 'DockRepositoryBaseBranchView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter',
		'toolbarActions'
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

{ #category : 'private' }
DockRepositoryBaseBranchView >> entitySelected: anEntity [

	self updateToolbar.
	"super entitySelected: anEntity."
]

{ #category : 'initialization' }
DockRepositoryBaseBranchView >> initializePresenters [

	self addStyle: 'dockRepositoryBranch'.

	toolbarPresenter := self instantiate: DockToolbarPresenter. 
	toolbarPresenter actions: self toolbarActions.

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

{ #category : 'private' }
DockRepositoryBaseBranchView >> selectedItemName [

	^ self selectedItem 
		ifNotNil: [ :each | each name ]
		ifNil: [ 'Unknown' ]
]

{ #category : 'initialization' }
DockRepositoryBaseBranchView >> toolbarActions [

	^ toolbarActions ifNil: [ toolbarActions := self actions actionsFor: #gitActions ]
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

{ #category : 'private' }
DockRepositoryBaseBranchView >> updateToolbar [

	toolbarActions allCommands do: [ :each | each updateEnableStatus ]
]
