Class {
	#name : 'PulsarRepositoryBaseBranchView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'toolbarActions',
		'isDisplayed'
	],
	#category : 'Pulsar-Tool-Repositories-View-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Branches'
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

{ #category : 'private - definitions' }
PulsarRepositoryBaseBranchView >> defineCompareActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #compareActions with: [ :group | group 
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

{ #category : 'private - definitions' }
PulsarRepositoryBaseBranchView >> defineGitCommonActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #gitActions with: [ :group | group 
		priority: 1;
		addActionWith: [ :action | action
			priority: -10; "at the begining"
			name: 'Fetch remotes';
			description: 'Fetch remote repositories';
			iconName: 'fetch';
			action: [ self doFetchRepositories ] ];
		addActionWith: [ :action | action 
			priority: -9;
			dynamicName: [ 'Checkout {1}' format: {  self selectedItemName } ];
			iconName: 'checkout-branch';
			description: 'Checkout branch';
			actionEnabled: [ self hasSelectedItem ];
			action: [ self doCheckoutSelectedBranchOrTag ] ] 
 
		]
]

{ #category : 'private - actions' }
PulsarRepositoryBaseBranchView >> doCheckout: aBranchOrTagModel [ 
	(PulsarRepositoryCheckoutWindow
		newApplication: self application
		model: (PulsarRepositoryCheckoutPreviewModel
			repositoryModel: self model
			commitish: aBranchOrTagModel entity))
		open
]

{ #category : 'private - actions' }
PulsarRepositoryBaseBranchView >> doCheckoutSelectedBranchOrTag [ 
	| branchOrTagModel |

	branchOrTagModel := self selectedItem.
	branchOrTagModel ifNil: [ ^ self ].	

	self doCheckout: branchOrTagModel
]

{ #category : 'private - actions' }
PulsarRepositoryBaseBranchView >> doCompareSelectedBranchWithAnother [
	| selectPresenter branchModel selectedBranch |

	selectedBranch := listPresenter selectedItem.
	selectedBranch ifNil: [ ^ self ].

	selectPresenter := (self 
			instantiate: PulsarRepositorySelectBranchPresenter 
			on: self model)
		title: 'Branch to compare';
		message: 'Select a branch to compare this one';
		yourself.
	(selectPresenter openModalWithParent: self window) isOk 
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

{ #category : 'private - actions' }
PulsarRepositoryBaseBranchView >> doFetchRepositories [

	self scheduleJob: [ :statusbar |
		statusbar pushMessage: 'Fetching remotes...'.
		self model newFetchAction
			onSuccess: [ self notifyRepositoryModified ];
			executeWithContext: self ]
]

{ #category : 'private - actions' }
PulsarRepositoryBaseBranchView >> doMergeBranchIntoHead: aBranchModel [

	(PulsarRepositoryMergeWindow
		newApplication: self application
		model: (PulsarRepositoryMergePreviewModel
			repositoryModel: self model
			branchModel: aBranchModel))
		open
]

{ #category : 'private - actions' }
PulsarRepositoryBaseBranchView >> doMergeSelectedBranchIntoHead [

	self hasSelectedItem ifFalse: [ ^ self ].
	
	self doMergeBranchIntoHead: self selectedItem
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> entityActivated: anEntityModel [

	self doCheckout: anEntityModel
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

	listPresenter := self newFilteringList
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
PulsarRepositoryBaseBranchView >> notifyRepositoryModified [

	"inform to all windows, as all may have things to do"
	self application resendAnnouncement: (PulsarRepositoryModified newValue: self model)
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
