Class {
	#name : 'DockRepositoryChangesView',
	#superclass : 'DockCollectionView',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'defaults' }
DockRepositoryChangesView class >> defaultDockPosition [

	^ SpPanelPosition new
		area: SpPanelArea start;
		yourself
]

{ #category : 'initialization' }
DockRepositoryChangesView >> connectPresenters [

	self flag: #RemoveMe. "I am overriding this because I do not want to mess with activations 
	while I am working..."
]

{ #category : 'layout' }
DockRepositoryChangesView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
DockRepositoryChangesView >> initializePresenters [

	self addStyle: 'dockRepositoryChangesView'.

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'dockRepositoryChangesTree';
		display: [ :aNode | aNode description ];
		displayIcon: [ :aNode | self iconNamed: aNode iconName ];
		children: [ :aNode | aNode children ];
		yourself
]

{ #category : 'initialization' }
DockRepositoryChangesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Changes'
]

{ #category : 'initialization' }
DockRepositoryChangesView >> updatePresenter [
	| spinner |
	
	self model ifNil: [ ^ self ].
	
	self flag: #TODO. "working status should be made through a notification, not directly here."
	spinner := self newSpinner.
	self withWindowDo: [ :w | w statusbar addPrefix: spinner ].
	
	self application schedule: [
		| diff |
		diff := self model diffToReferenceCommit.
		"then show it in UI thread"
		self application defer: [
			listPresenter 
				roots: diff children;
				expandAll ].
			
		self withWindowDo: [ :w | w statusbar remove: spinner ] ].
]
