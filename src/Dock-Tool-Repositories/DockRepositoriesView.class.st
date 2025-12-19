Class {
	#name : 'DockRepositoriesView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'listToolbarPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'defaults' }
DockRepositoriesView class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea start;
		row: 1;
		yourself
]

{ #category : 'initialization' }
DockRepositoriesView >> connectPresenters [

	listPresenter outputSelectionPort
		transmitDo: [ :aRepositoryModel | self entitySelected: aRepositoryModel ].
	listPresenter outputActivationPort
		transmitDo: [ :aRepositoryModel | self doOpenRepository: aRepositoryModel ]
]

{ #category : 'layout' }
DockRepositoriesView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: listToolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - definitions' }
DockRepositoriesView >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder 
		addGroup: #actions with: [ :group | group 
			priority: 10;
			beDisplayedAsGroup;
			addActionWith: [ :action | action
				priority: 1;
				name: 'Add repository';
				description: 'Add a new repository';
				iconName: 'add';
				action: [ self doAddRepository ] ];
			addActionWith: [ :action | action
				priority: 1;
				name: 'Repair repository';
				description: 'Repair repository';
				iconName: 'repair';
				actionEnabled: [ self hasSelectedRepository and: [ self selectedRepository needsRepair ] ];
				action: [ self doRepairSelectedRepository ] ] ]
]

{ #category : 'private - actions' }
DockRepositoriesView >> doAddRepository [
	
	((self instantiate: DockRegisterRepositoryDialog) 
		onAccept: [ self repositoryModified ])
		asModalWindow
			owner: self window;
			open
]

{ #category : 'private - actions' }
DockRepositoriesView >> doClose [

	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - actions' }
DockRepositoriesView >> doOpenRepository: aRepositoryModel [

	(DockRepositoryBrowser 
		newApplication: self application
		model: aRepositoryModel)
		open
]

{ #category : 'private - actions' }
DockRepositoriesView >> doRepairSelectedRepository [
	| result |
	
	self flag: #TODO. "in fact, this should be a bit better (we have helps and that
	we can use, just I'm lazy to create a new dialog right now)"
	result := self application newSelect
		title: 'Repository broken';
		message: 'Select from available repair actions';
		items: self selectedRepository repairActions;
		display: [ :aRepaitAction | aRepaitAction title ];
		openModalWithParent: self window.

	result ifNil: [ ^ self ].
	
	
]

{ #category : 'private' }
DockRepositoriesView >> entitySelected: aRepositoryModel [

	self updateToolbar
]

{ #category : 'events' }
DockRepositoriesView >> eventRepositoryModified: ann [

	self updatePresenter
]

{ #category : 'private - testing' }
DockRepositoriesView >> hasSelectedRepository [

	^ self selectedRepository isNotNil
]

{ #category : 'initialization' }
DockRepositoriesView >> initializePresenters [

	self addStyle: 'dockRepositories'.

	listToolbarPresenter := self instantiate: DockToolbarPresenter.
	listToolbarPresenter actions: self actions.
	listToolbarPresenter addPresenter: (self newToolbar 
		beIcons;
		add: (self newButton
			addStyle: 'flat';
			icon: (self iconNamed: 'close');
			help: 'Close repositories';
			action: [ self doClose ];
			yourself);
		yourself).

	listPresenter := self newFilteringList
		addStyle: 'stList';
		rowPresenterClass: DockRepositoryRow;
		display: [ :aRepositoryModel | aRepositoryModel name ];
		enableSearch;
		yourself
]

{ #category : 'initialization' }
DockRepositoriesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Repository'
]

{ #category : 'initialization' }
DockRepositoriesView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: DockRepositoryModified
		send: #eventRepositoryModified:
		to: self
]

{ #category : 'private - accessing' }
DockRepositoriesView >> selectedRepository [

	^ listPresenter ifNotNil: #selectedItem
]

{ #category : 'accessing - snapshot' }
DockRepositoriesView >> snapshot [

	^ DockRepositoriesSnapshot on: self
]

{ #category : 'initialization' }
DockRepositoriesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	listPresenter updateItemsKeepingSelection: (self model repositories sorted: #name ascending)
]

{ #category : 'private' }
DockRepositoriesView >> updateToolbar [

	self actions allCommands do: [ :each | each updateEnableStatus ]
]
