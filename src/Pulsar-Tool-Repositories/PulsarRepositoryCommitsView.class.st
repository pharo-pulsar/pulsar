Class {
	#name : 'PulsarRepositoryCommitsView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'isDisplayed'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'defaults' }
PulsarRepositoryCommitsView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 3;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> commitsToRetrieve [

	^ 300
]

{ #category : 'layout' }
PulsarRepositoryCommitsView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'accessing - actions' }
PulsarRepositoryCommitsView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #gitActions with: [ :group | group  ]
]

{ #category : 'events' }
PulsarRepositoryCommitsView >> eventRepositoryModified: ann [

	ann value = self model ifFalse: [ ^ self ].
	
	self updatePresenter
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> initialize [ 
	
	isDisplayed := false.
	super initialize.
	self whenDisplayDo: [
		isDisplayed := true.
		self updatePresenter ]
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> initializePresenters [
	
	self addStyle: 'pulsarRepositoryCommit'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
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
PulsarRepositoryCommitsView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Commits'
]

{ #category : 'private' }
PulsarRepositoryCommitsView >> notifyRepositoryModified [

	"inform to all windows, as all may have things to do"
	self application resendAnnouncement: (PulsarRepositoryModified newValue: self model)
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarRepositoryModified
		send: #eventRepositoryModified: 
		to: self
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	isDisplayed ifFalse: [ ^ self ].
	
	self scheduleJob: [ :statusbar |
		| items |
		statusbar pushMessage: ('Retrieving commits of {1}...' format: { self model name }).
		items := self model commitsTo: self commitsToRetrieve.
		self scheduleTask: [ 
			self application defer: [ 
				listPresenter items: items ] ] ]
]
