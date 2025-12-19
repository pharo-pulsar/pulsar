Class {
	#name : 'DockRepositoryCommitsView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'defaults' }
DockRepositoryCommitsView class >> defaultDockPosition [

	^ SpPanelPosition new
		area: SpPanelArea start;
		row: 3;
		yourself
]

{ #category : 'layout' }
DockRepositoryCommitsView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'accessing - actions' }
DockRepositoryCommitsView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #gitActions with: [ :group | group  ]
]

{ #category : 'events' }
DockRepositoryCommitsView >> eventRepositoryModified: ann [

	ann value = self model ifFalse: [ ^ self ].
	
	self updatePresenter
]

{ #category : 'initialization' }
DockRepositoryCommitsView >> initializePresenters [
	
	self addStyle: 'dockRepositoryCommitView'.

	toolbarPresenter := self instantiate: DockToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #gitActions).
	
	listPresenter := self newEasyColumnView
		addStyle: 'stList';
		addColumn: (SpColumnViewColumn new 
			title: 'Commit';
			setup: [ :aPresenter | aPresenter newLabel addStyle: 'commitId'; yourself ];
			bind: [ :aPresenter :aCommitModel | 
				aPresenter label: aCommitModel shortCommitId.
				aCommitModel isOutgoing
					ifTrue: [ aPresenter addStyle: 'outgoing' ]
					ifFalse: [ aPresenter removeStyle: 'outgoing' ]];
			yourself);
		addColumn: (SpColumnViewColumn new 
			title: 'Au';
			setup: [ :aPresenter | aPresenter newLabel addStyle: 'commitAuthor'; yourself ];
			bind: [ :aPresenter :aCommitModel | aPresenter label: aCommitModel shortCommitAuthor ];
			yourself);
		addColumn: (SpColumnViewColumn new 
			title: 'Message';
			setup: [ :aPresenter | aPresenter newLabel addStyle: 'commitMessage'; yourself ];
			bind: [ :aPresenter :aCommitModel | aPresenter label: aCommitModel shortCommitMessage ];
			yourself);
		yourself
]

{ #category : 'initialization' }
DockRepositoryCommitsView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Commits'
]

{ #category : 'initialization' }
DockRepositoryCommitsView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: DockRepositoryModified
		send: #eventRepositoryModified: 
		to: self
]

{ #category : 'private' }
DockRepositoryCommitsView >> repositoryModified [

	"inform to all windows, as all may have things to do"
	self application resendAnnouncement: (DockRepositoryModified newValue: self model)
]

{ #category : 'initialization' }
DockRepositoryCommitsView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self scheduleJob: [
		listPresenter items: (self model commitsTo: 300) ]
]
