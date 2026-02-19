"
A panel to show registered repositories. 
"
Class {
	#name : 'PulsarRepositoriesView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'listToolbarPresenter',
		'hideSystemProjects',
		'toggleSystemProjectsButtonPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'defaults' }
PulsarRepositoriesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 3;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoriesView >> addVisibilityToolbar [
	
	(toggleSystemProjectsButtonPresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: #systemRepository);
		help: 'Toggle visibility (hide/show) of system projects';
		state: self isHideSystemProjects;
		whenChangedDo: [ :state | self toggleSystemProjects: state ];
		yourself.
	
	listToolbarPresenter addPresenter: (self newToolbar
		displayMode: self application toolbarDisplayMode;
		add: toggleSystemProjectsButtonPresenter;
		yourself)
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
	
	self scheduleJob: [ :statusbar |
		| repository |
		statusbar pushMessage: 'Registering repository...'.
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
	| result repositoryModel repairActions |
		
	repositoryModel := self selectedRepository.
	repairActions := repositoryModel repairActions.
	repairActions do: [ :each | each context: self ].
	
	self flag: #TODO. "in fact, this should be a bit better (we have helps and that
	we can use, just I'm lazy to create a new dialog right now)"
	result := self application newSelect
		title: 'Repository broken';
		message: 'Select from available repair actions';
		items: repairActions;
		display: [ :aRepaitAction | aRepaitAction title ];
		openModalWithParent: self window.
	result ifNil: [ ^ self ].
	
	result 
		onSuccess: [ self updatePresenter ];
		execute
]

{ #category : 'private' }
PulsarRepositoriesView >> entitySelected: aRepositoryModel [

	self updateToolbar
]

{ #category : 'events' }
PulsarRepositoriesView >> eventRepositoryModified: ann [

	self updatePresenter
]

{ #category : 'private' }
PulsarRepositoriesView >> filterRepositories: aCollection [

	hideSystemProjects ifFalse: [ ^ aCollection ].

	^ aCollection reject: [ :each | 
		each isSystemRepository ]
]

{ #category : 'private - testing' }
PulsarRepositoriesView >> hasSelectedRepository [

	^ self selectedRepository isNotNil
]

{ #category : 'private' }
PulsarRepositoriesView >> hideSystemProjects: aBoolean [

	hideSystemProjects = aBoolean ifTrue: [ ^ self ].
	
	hideSystemProjects := aBoolean.
	"this will probablu trigger an update"
	toggleSystemProjectsButtonPresenter 
		ifNotNil: [ :aPresenter | aPresenter state: aBoolean ]
]

{ #category : 'initialization' }
PulsarRepositoriesView >> initialize [

	hideSystemProjects := false.
	super initialize
]

{ #category : 'initialization' }
PulsarRepositoriesView >> initializePresenters [

	self addStyle: 'pulsarRepositories'.

	listToolbarPresenter := self instantiate: PulsarToolbarPresenter.
	listToolbarPresenter actions: (self actions actionsFor: #actions).
	
	self addVisibilityToolbar.
	
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

{ #category : 'private - testing' }
PulsarRepositoriesView >> isHideSystemProjects [

	^ hideSystemProjects
]

{ #category : 'private' }
PulsarRepositoriesView >> panelPlacedIconName [

	^ 'repositories'
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

{ #category : 'private' }
PulsarRepositoriesView >> toggleSystemProjects: aBoolean [

	hideSystemProjects = aBoolean ifTrue: [ ^ self ].

	hideSystemProjects := aBoolean.
	self updatePresenter
]

{ #category : 'initialization' }
PulsarRepositoriesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	listPresenter updateItemsKeepingSelection: (self filterRepositories: (self model repositories sorted: #name ascending))
]

{ #category : 'private' }
PulsarRepositoriesView >> updateToolbar [

	self actions allCommands do: [ :each | each updateEnableStatus ]
]
