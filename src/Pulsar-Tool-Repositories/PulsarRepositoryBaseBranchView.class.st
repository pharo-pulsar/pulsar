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

{ #category : 'accessing - actions' }
PulsarRepositoryBaseBranchView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #actions with: [ :group | group 
		priority: 100;
		addActionWith: [ :action | action 
			dynamicName: [ 'Compare {1} with Working Copy' format: { self selectedItemName }];
			description: 'Compare this branch with current Working Copy';
			actionEnabled: [ self hasSelectedItem ];
			action: [ self doCompareSelectedBranchWithWorkingCopy ] ];
		addActionWith: [ :action | action 
			dynamicName: [ 'Compare {1} with branch' format: { self selectedItemName }];
			description: 'Compare this branch with another branch';
			actionEnabled: [ self hasSelectedItem ];
			action: [ self doCompareSelectedBranchWithAnother ] ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryBaseBranchView >> doCompareSelectedBranchWithAnother [
	| selectPresenter branchModel selectedBranch |

	selectedBranch := listPresenter selectedItem.
	selectedBranch ifNil: [ ^ self ].

	selectPresenter := (self context 
			instantiate: PulsarRepositorySelectBranchPresenter 
			on: self repositoryModel)
		title: 'Branch to compare';
		message: 'Select a branch to compare this one';
		yourself.
	(selectPresenter openModalWithParent: self context window) isOk 
		ifFalse: [ ^ self ].
	
	branchModel := selectPresenter selectedModel.
	
	(self 
		instantiate: PulsarRepositoryCommitDiffWindow 
		on: (selectedBranch newDiffModelToCommitishModel: branchModel))
		open
]

{ #category : 'private - actions' }
PulsarRepositoryBaseBranchView >> doCompareSelectedBranchWithWorkingCopy [
	| selectedBranch |

	selectedBranch := listPresenter selectedItem.
	selectedBranch ifNil: [ ^ self ].

	(self 
		instantiate: PulsarRepositoryCommitDiffWindow 
		on: selectedBranch newDiffModelToWorkingCopy)
		open
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
		actions: self actions;
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
		branches := self maybeSort: (self branches ifNil: [ #() ]).
		self application 
			defer: [ listPresenter items: branches ] ]
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> updateToolbar [

	self toolbarActions allCommands do: [ :each | each updateEnableStatus ]
]
