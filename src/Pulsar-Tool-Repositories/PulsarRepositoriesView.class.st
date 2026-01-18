Class {
	#name : 'PulsarRepositoriesView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'listToolbarPresenter'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'defaults' }
PulsarRepositoriesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 1;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoriesView >> connectPresenters [

	listPresenter outputSelectionPort
		transmitDo: [ :aRepositoryModel | self entitySelected: aRepositoryModel ].
	listPresenter outputActivationPort
		transmitDo: [ :aRepositoryModel | self doOpenRepository: aRepositoryModel ]
]

{ #category : 'layout' }
PulsarRepositoriesView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: listToolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - definitions' }
PulsarRepositoriesView >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #actions with: [ :group | group 
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
PulsarRepositoriesView >> doAddRepository [
	| presenter dialog |
	
	presenter := self instantiate: PulsarRegisterRepositoryDialog.
	
	dialog := presenter asModalWindow
		owner: self window;
		open.
	dialog isOk ifFalse: [ ^ self ].
	
	self scheduleJob: [
		| repository |
		repository := presenter repositoryCreator createRepository.
		repository register.
		self model resetRepositories.
		self updatePresenter ]
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doClose [

	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doOpenRepository: aRepositoryModel [

	(PulsarRepositoryBrowser 
		newApplication: self application
		model: aRepositoryModel)
		open
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doRepairSelectedRepository [
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
PulsarRepositoriesView >> entitySelected: aRepositoryModel [

	self updateToolbar
]

{ #category : 'events' }
PulsarRepositoriesView >> eventRepositoryModified: ann [

	self updatePresenter
]

{ #category : 'private - testing' }
PulsarRepositoriesView >> hasSelectedRepository [

	^ self selectedRepository isNotNil
]

{ #category : 'initialization' }
PulsarRepositoriesView >> initializePresenters [

	self addStyle: 'pulsarRepositories'.

	listToolbarPresenter := self instantiate: PulsarToolbarPresenter.
	listToolbarPresenter actions: (self actions actionsFor: #actions).
	listToolbarPresenter 
		addPresenterCloseButton: 'Close repositories' 
		action: [ self doClose ].

	listPresenter := self newFilteringList
		addStyle: 'stList';
		rowPresenterClass: PulsarRepositoryRow;
		display: [ :aRepositoryModel | aRepositoryModel name ];
		enableSearch;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoriesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Repository'
]

{ #category : 'initialization' }
PulsarRepositoriesView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarRepositoryModified
		send: #eventRepositoryModified:
		to: self
]

{ #category : 'private - accessing' }
PulsarRepositoriesView >> selectedRepository [

	^ listPresenter ifNotNil: #selectedItem
]

{ #category : 'accessing - snapshot' }
PulsarRepositoriesView >> snapshot [

	^ PulsarRepositoriesSnapshot on: self
]

{ #category : 'initialization' }
PulsarRepositoriesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	listPresenter updateItemsKeepingSelection: (self model repositories sorted: #name ascending)
]

{ #category : 'private' }
PulsarRepositoriesView >> updateToolbar [

	self actions allCommands do: [ :each | each updateEnableStatus ]
]
