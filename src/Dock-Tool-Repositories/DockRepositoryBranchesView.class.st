Class {
	#name : 'DockRepositoryBranchesView',
	#superclass : 'DockBaseView',
	#instVars : [
		'toolbarPresenter',
		'localPresenter',
		'remotePresenter',
		'tagPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'defaults' }
DockRepositoryBranchesView class >> defaultDockPosition [

	^ SpPanelPosition new
		area: SpPanelArea start;
		row: 2;
		yourself
]

{ #category : 'layout' }
DockRepositoryBranchesView >> defaultLayout [

	^ SpTabLayout new
		add: localPresenter label: 'Local';
		add: remotePresenter label: 'Remote';
		add: tagPresenter label: 'Tags';
		yourself
]

{ #category : 'events' }
DockRepositoryBranchesView >> eventRepositoryModified: ann [

	ann value = self model ifFalse: [ ^ self ].
	
	{ localPresenter. remotePresenter. tagPresenter } 
		do: [ :each | each updatePresenter ]
]

{ #category : 'initialization' }
DockRepositoryBranchesView >> initializePresenters [

	localPresenter := self instantiate: DockRepositoryLocalBranchView on: self model.
	remotePresenter := self instantiate: DockRepositoryRemoteBranchView on: self model.
	tagPresenter := self instantiate: DockRepositoryTagBranchView on: self model
]

{ #category : 'initialization' }
DockRepositoryBranchesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Branches'
]

{ #category : 'accessing - model' }
DockRepositoryBranchesView >> model: aModel [ 

	super model: aModel.
	localPresenter model: aModel.
	remotePresenter model: aModel.
	tagPresenter model: aModel
]

{ #category : 'initialization' }
DockRepositoryBranchesView >> registerToEvents [

	super registerToEvents.
	
	self announcer 
		when: DockRepositoryModified
		send: #eventRepositoryModified:
		to: self
]

{ #category : 'initialization' }
DockRepositoryBranchesView >> updatePresenter [

	
]
