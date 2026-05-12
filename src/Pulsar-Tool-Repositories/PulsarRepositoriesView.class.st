"
A panel to show registered repositories. 
"
Class {
	#name : 'PulsarRepositoriesView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'listToolbarPresenter',
		'hideSystemProjects',
		'toggleSystemProjectsButtonPresenter',
		'updating',
		'toggleDirtyProjectsButtonPresenter',
		'hideNonDirtyProjects'
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
	
	(toggleDirtyProjectsButtonPresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: #dirtyProject);
		help: 'Toggle visibility (hide/show) of dirty projects';
		state: self isHideNonDirtyProjects;
		whenChangedDo: [ :state | self toggleDirtyProjects: state ];
		yourself.
	
	(toggleSystemProjectsButtonPresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: #systemRepository);
		help: 'Toggle visibility (hide/show) of system projects';
		state: self isHideSystemProjects;
		whenChangedDo: [ :state | self toggleSystemProjects: state ];
		yourself.
	
	listToolbarPresenter addPresenter: (self newToolbar
		displayMode: self application toolbarDisplayMode;
		add: toggleDirtyProjectsButtonPresenter;
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
			actionEnabled: [ self hasSelectedRepository and: [ self selectedRepositoryAcceptsRepair ] ];
			action: [ self doRepairSelectedRepository ] ] ]
]

{ #category : 'private - definitions' }
PulsarRepositoriesView >> defineContextActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #contextActions with: [ :group | group 
		addGroupWith: [ :aGroup | aGroup 
			name: 'Repoisitory actions';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				dynamicName: [ 'Open {1}' format: { self selectedRepositoryName } ];
				description: 'Open selected repository';
				actionEnabled: [ self hasSelectedRepository ];
				action: [ self doOpenSelectedRepository ] ];
			addActionWith: [ :action | action 
				dynamicName: [ 'Repair {1}' format: { self selectedRepositoryName } ];
				description: 'Open repair actions for selected repository';
				actionEnabled: [ self hasSelectedRepository and: [ self selectedRepositoryAcceptsRepair ] ];
				action: [ self doRepairSelectedRepository ] ] ];
		addGroupWith: [ :dangerGroup | dangerGroup
			name: 'DANGER ZONE';
			beDisplayedAsGroup;
			addActionWith: [ :action | action
				priority: 1000;
				dynamicName: [ 'Forget {1}' format: { self selectedRepositoryName } ];
				description: 'Forget this repository';
				shortcutKey: $x actionModifier;
				actionEnabled: [ self hasSelectedRepository ];
				action: [ self doForgetSelectedRepository ] ] ] ]
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
		statusbar pushMessage: 'Registering repository...'.
		self application suspendAnnouncementsDuring: [
			| repository |
			repository := presenter repositoryCreator createRepository.
			repository register ].
		self model resetRepositories.
		self updatePresenter ]
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doClose [

	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doForgetRepository: aRepositoryModel [
	| shouldRemove |

	shouldRemove := self application newConfirm
		title: 'Forget repository';
		message: ('Remove <b>{1}</b> from your repositories list.
<i><span foreground="red">NOTICE:</span> Repository sources will remain in disk.</i>' format: { aRepositoryModel name });
		acceptLabel: 'Forget';
		openModal.
	shouldRemove ifFalse: [ ^ self ].
	
	self scheduleJob: [ :statusbar |
		statusbar pushMessage: ('Forgetting {1}...' format: { aRepositoryModel name }).
		aRepositoryModel forgetAction 
			onSuccess: [ 
				self model resetRepositories.
				self updatePresenter ];
			executeWithContext: self ]
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doForgetSelectedRepository [
	
	self doForgetRepository: self selectedRepository
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doOpenRepository: aRepositoryModel [

	"do not try to open if it is broken... instead, open repair window"
	aRepositoryModel needsRepair ifTrue: [
		self doRepairRepository: aRepositoryModel.
		^ self ]. 

	(PulsarRepositoryBrowser 
		newApplication: self application
		model: aRepositoryModel)
		open
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doOpenSelectedRepository [
	
	self doOpenRepository: self selectedRepository
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doRepairRepository: aRepositoryModel [
	| choosenRepairAction repairActions |
		
	repairActions := aRepositoryModel repairActions.
	repairActions do: [ :each | each context: self ].
	
	self flag: #TODO. "in fact, this should be a bit better (we have helps and that
	we can use, just I'm lazy to create a new dialog right now)"
	choosenRepairAction := self application newSelect
		title: 'Repository broken';
		message: 'Select from available repair actions';
		items: repairActions;
		display: [ :aRepaitAction | aRepaitAction title ];
		openModalWithParent: self window.
	choosenRepairAction ifNil: [ ^ self ].
	
	self scheduleTask: [
		aRepositoryModel resetDiff.
		choosenRepairAction
			onSuccess: [ self notifyRepositoryModified: aRepositoryModel ];
			execute ]
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> doRepairSelectedRepository [
	
	self doRepairRepository: self selectedRepository
]

{ #category : 'private' }
PulsarRepositoriesView >> entitySelected: aRepositoryModel [

	self updateToolbar
]

{ #category : 'events' }
PulsarRepositoriesView >> eventMetaModelElementChanged: ann [

	updating ifTrue: [ ^ self ].

	(listPresenter items 
		anySatisfy: [ :each | each registeredStatusChanged ])
		ifFalse: [ ^ self ] .
	
	self updatePresenter
]

{ #category : 'events' }
PulsarRepositoriesView >> eventMetacelloExecutionEnd: ann [
	"when metacello was executed, there may be projects changed, we need to reset them."
	self model resetRepositories.
	self updatePresenter
]

{ #category : 'events' }
PulsarRepositoriesView >> eventRepositoryModified: ann [

	updating ifTrue: [ ^ self ].
	
	self updatePresenter
]

{ #category : 'private' }
PulsarRepositoriesView >> filterRepositories: aCollection [
	| filteredCollection |

	filteredCollection := aCollection.
	hideSystemProjects ifTrue: [ 
		filteredCollection := filteredCollection reject: [ :each | each isSystemRepository ] ].
	hideNonDirtyProjects ifTrue: [ 
		filteredCollection := filteredCollection select: [ :each | each isDirty ] ].

	^ filteredCollection
]

{ #category : 'private - testing' }
PulsarRepositoriesView >> hasSelectedRepository [

	^ self selectedRepository isNotNil
]

{ #category : 'private' }
PulsarRepositoriesView >> hideSystemProjects: aBoolean [

	hideSystemProjects = aBoolean ifTrue: [ ^ self ].
	
	hideSystemProjects := aBoolean.
	toggleSystemProjectsButtonPresenter ifNotNil: [ :aPresenter |
		"prevent double update"
		self updatingWhile: [
			aPresenter state: aBoolean ].
		self updatePresenter ]
]

{ #category : 'initialization' }
PulsarRepositoriesView >> initialize [

	updating := false.
	hideSystemProjects := true.
	hideNonDirtyProjects := false.
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
		actions: (self actions actionsFor: #contextActions);
		enableSearch;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoriesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Repository'
]

{ #category : 'testing' }
PulsarRepositoriesView >> isHideNonDirtyProjects [

	^ hideNonDirtyProjects
]

{ #category : 'private - testing' }
PulsarRepositoriesView >> isHideSystemProjects [

	^ hideSystemProjects
]

{ #category : 'private' }
PulsarRepositoriesView >> maybeSort: aCollection [ 

	^ aCollection sorted: #name ascending
]

{ #category : 'private' }
PulsarRepositoriesView >> notifyRepositoryModified: aModel [

	logger trace: aModel. 

	self application resendAnnouncement: (PulsarRepositoryModified newValue: aModel)
]

{ #category : 'private' }
PulsarRepositoriesView >> panelPlacedIconName [

	^ 'repositories'
]

{ #category : 'private' }
PulsarRepositoriesView >> postRestoreSnapshot: aSnapshot [
	| oldHideSystemProjects oldHideNonDirtyProjects |


	oldHideSystemProjects := hideSystemProjects. 
	oldHideNonDirtyProjects := hideNonDirtyProjects.
	hideSystemProjects := aSnapshot isHideSystemProjects.
	hideSystemProjects = oldHideSystemProjects ifFalse: [
		toggleSystemProjectsButtonPresenter ifNotNil: [ :aPresenter |
			"prevent double update"
			self updatingWhile: [
				aPresenter state: hideSystemProjects ] ] ].
			
	hideNonDirtyProjects := aSnapshot isHideNonDirtyProjects.
	hideNonDirtyProjects = oldHideNonDirtyProjects ifFalse: [
		toggleDirtyProjectsButtonPresenter ifNotNil: [ :aPresenter |
			"prevent double update"
			self updatingWhile: [
				aPresenter state: hideNonDirtyProjects ] ] ].
								
	"update if any changed"
	{ oldHideSystemProjects. oldHideNonDirtyProjects } = { hideSystemProjects. hideNonDirtyProjects}
		ifFalse: [ self updatePresenter ]
	
]

{ #category : 'initialization' }
PulsarRepositoriesView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarRepositoryModified
		send: #eventRepositoryModified:
		to: self
]

{ #category : 'initialization' }
PulsarRepositoriesView >> registerToSystemEvents [

	self announcer 
		when: PackageAnnouncement, ClassAnnouncement, MethodAnnouncement 
			send: #eventMetaModelElementChanged:
			to: self;
		when: MetacelloExecutionEndAnnouncement
			send: #eventMetacelloExecutionEnd:
			to: self
]

{ #category : 'private - accessing' }
PulsarRepositoriesView >> selectedRepository [

	^ listPresenter ifNotNil: #selectedItem
]

{ #category : 'private - testing' }
PulsarRepositoriesView >> selectedRepositoryAcceptsRepair [

	^ self selectedRepository acceptsRepair
]

{ #category : 'private - accessing' }
PulsarRepositoriesView >> selectedRepositoryName [

	^ listPresenter selectedItem 
		ifNotNil: [ :aModel | aModel name ]
		ifNil: [ 'NONAME' ]
]

{ #category : 'accessing - snapshot' }
PulsarRepositoriesView >> snapshot [

	^ PulsarRepositoriesSnapshot on: self
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> toggleDirtyProjects: aBoolean [

	hideNonDirtyProjects = aBoolean ifTrue: [ ^ self ].

	hideNonDirtyProjects := aBoolean.
	self updatePresenter
]

{ #category : 'private - actions' }
PulsarRepositoriesView >> toggleSystemProjects: aBoolean [

	hideSystemProjects = aBoolean ifTrue: [ ^ self ].

	hideSystemProjects := aBoolean.
	self updatePresenter
]

{ #category : 'initialization' }
PulsarRepositoriesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self scheduleJob: [
		| filteredRepositories |
		updating ifFalse: [
			filteredRepositories := self maybeSort: (self filterRepositories: self model repositories).
			listPresenter updateItemsKeepingSelection: filteredRepositories ] ]
]

{ #category : 'private' }
PulsarRepositoriesView >> updateToolbar [

	self actions allCommands do: [ :each | each updateEnableStatus ]
]

{ #category : 'private - updating' }
PulsarRepositoriesView >> updatingWhile: aBlock [
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	aBlock 
		ensure: [ updating := oldUpdating ]
]
