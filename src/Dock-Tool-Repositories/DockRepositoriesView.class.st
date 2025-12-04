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

{ #category : 'accessing - actions' }
DockRepositoriesView class >> defineActionsOn: aBuilder [
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
				action: [ :aContext | aContext doAddRepository ] ] ]
]

{ #category : 'initialization' }
DockRepositoriesView >> connectPresenters [

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

{ #category : 'private - actions' }
DockRepositoriesView >> doOpenRepository: aRepositoryModel [

	(DockRepositoryBrowser 
		newApplication: self application
		model: aRepositoryModel)
		open
]

{ #category : 'initialization' }
DockRepositoriesView >> initializePresenters [

	self addStyle: 'dockRepositories'.

	listToolbarPresenter := self instantiate: DockToolbarPresenter.
	listToolbarPresenter actions: self actions.	

	listPresenter := self newEasyListView
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
DockRepositoriesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	listPresenter items: (self model repositories sorted: #name ascending)
]
