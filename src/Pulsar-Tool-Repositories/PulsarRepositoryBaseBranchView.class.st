Class {
	#name : 'PulsarRepositoryBaseBranchView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'toolbarActions',
		'isDisplayed'
	],
	#category : 'Pulsar-Tool-Repositories-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Branches'
}

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> branches [

	self subclassResponsibility
]

{ #category : 'layout' }
PulsarRepositoryBaseBranchView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> entitySelected: anEntity [

	self updateToolbar.
	super entitySelected: anEntity
]

{ #category : 'initialization' }
PulsarRepositoryBaseBranchView >> initialize [

	isDisplayed := false.
	super initialize.
	self whenDisplayDo: [
		isDisplayed := true.
		self updatePresenter ]
]

{ #category : 'initialization' }
PulsarRepositoryBaseBranchView >> initializePresenters [

	self addStyle: 'pulsarRepositoryBranch'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter. 
	toolbarPresenter actions: self toolbarActions.

	listPresenter := self newEasyListView
		addStyle: 'stList';
		rowPresenterClass: PulsarRepositoryBranchRow;
		display: [ :aBranchModel | aBranchModel name ];
		yourself
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> labels [

	self subclassResponsibility
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> maybeSort: aCollection [

	^ aCollection
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> selectedItemName [

	^ self selectedItem 
		ifNotNil: [ :each | each name ]
		ifNil: [ 'Unknown' ]
]

{ #category : 'initialization' }
PulsarRepositoryBaseBranchView >> toolbarActions [

	^ toolbarActions ifNil: [ toolbarActions := self actions actionsFor: #gitActions ]
]

{ #category : 'initialization' }
PulsarRepositoryBaseBranchView >> updatePresenter [

	self model ifNil: [ ^ self ].
	isDisplayed ifFalse: [ ^ self ].

	self window scheduleJob: [ :statusbar |
		| branches |
		statusbar pushMessage: ('Retrieving {1}...' format: { self label }).
		branches := self maybeSort: self branches.
		self application 
			defer: [ listPresenter items: branches ] ]
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> updateToolbar [

	self toolbarActions allCommands do: [ :each | each updateEnableStatus ]
]
