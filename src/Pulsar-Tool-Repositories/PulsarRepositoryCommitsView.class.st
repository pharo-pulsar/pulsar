Class {
	#name : 'PulsarRepositoryCommitsView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'#toolbarPresenter',
		'#isDisplayed',
		'#lastBranchSelected => WeakSlot',
		'#updatingList'
	],
	#category : 'Pulsar-Tool-Repositories-View-Commit',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Commit'
}

{ #category : 'private' }
PulsarRepositoryCommitsView class >> colorPalette [

	^ Color purpleColors
]

{ #category : 'defaults' }
PulsarRepositoryCommitsView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 3;
		yourself
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
PulsarRepositoryCommitsView >> eventBranchSelected: ann [
	| branchSelected | 

	branchSelected := ann value.
	branchSelected = lastBranchSelected ifTrue: [ ^ self ].
	lastBranchSelected := branchSelected.
	
	self updatePresenter
]

{ #category : 'events' }
PulsarRepositoryCommitsView >> eventRepositoryModified: ann [

	ann value = self model ifFalse: [ ^ self ].
	ann affectsCommits ifFalse: [ ^ self ].

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
		addStyle: 'pulsarCommitList';
		addColumn: (SpColumnViewColumn new 
			beNotExpandable;
			title: 'Commit';
			setup: [ :aPresenter | aPresenter newLabel addStyle: 'commitId'; yourself ];
			bind: [ :aPresenter :aCommitModel | 
				aPresenter label: aCommitModel shortId.
				(self model isOutgoingCommit: aCommitModel)
					ifTrue: [ aPresenter addStyle: 'outgoing' ]
					ifFalse: [ aPresenter removeStyle: 'outgoing' ] ];
			yourself);
		addColumn: (SpColumnViewColumn new 
			beNotExpandable;
			title: 'Au';
			setup: [ :aPresenter | aPresenter newLabel addStyle: 'commitAuthor'; yourself ];
			bind: [ :aPresenter :aCommitModel |
				aCommitModel ifNotNil: [
					aPresenter 
						label: aCommitModel shortCommitAuthor;
						help: aCommitModel normalizedCommitAuthor ] ];
			yourself);
		addColumn: (SpColumnViewColumn new 
			title: 'Summary';
			setup: [ :aPresenter | 
				(aPresenter instantiate: PulsarRepositoryRiverRow)
					branchPalette: self class colorPalette;
					yourself ];
			bind: [ :aPresenter :aCommitModel | aPresenter model: aCommitModel ];
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Commits'
]

{ #category : 'private' }
PulsarRepositoryCommitsView >> listSizeChangedFrom: oldSize to: newSize [
	
	newSize > oldSize ifFalse: [ ^ self ].
	
	self scheduleJob: [
		listPresenter contentView withAdapterDo: [ :anAdapter |
			anAdapter innerWidgetDo: [ :w |
				w selectionModel model writeSlotNamed: 'items' value: listPresenter items copy.
				w selectionModel
					itemsChangedAt: oldSize
					removed: 0
					added: newSize - oldSize
			]
		] 
	]
]

{ #category : 'private - announcing' }
PulsarRepositoryCommitsView >> notifyActivateEntity: aGitRiverLayoutRow [
	| commitModel |

	aGitRiverLayoutRow ifNil: [ ^ self ].
	commitModel := self model newCommitModelWithId: aGitRiverLayoutRow  id.
	self notificationCenter announce: commitModel newActivationAnnouncement
]

{ #category : 'private' }
PulsarRepositoryCommitsView >> notifyRepositoryModified [

	"inform to all windows, as all may have things to do"
	self application resendAnnouncement: (PulsarRepositoryModified newValue: self model)
]

{ #category : 'private - announcing' }
PulsarRepositoryCommitsView >> notifySelectEntity: aGitRiverLayoutRow [
	| commitModel |

	aGitRiverLayoutRow ifNil: [ ^ self ].
	commitModel := self model newCommitModelWithId: aGitRiverLayoutRow id.
	self notificationCenter announce: commitModel newSelectionAnnouncement
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> numberOfCommitsToRetrieve [

	^ 150
]

{ #category : 'private' }
PulsarRepositoryCommitsView >> panelPlacedIconName [

	^ 'commits'
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarRepositoryModified send: #eventRepositoryModified: to: self;
		when: PulsarRepositoryBranchModelSelected send: #eventBranchSelected: to: self
]

{ #category : 'private' }
PulsarRepositoryCommitsView >> retrieveCommits [

	^ self model newRiverInBranch: lastBranchSelected
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	isDisplayed ifFalse: [ ^ self ].
	
	self scheduleJob: [ :statusbar |
		| itemsModel |
		statusbar pushMessage: ('Retrieving commits of {1}...' format: { self model name }).
		itemsModel := self retrieveCommits.
		self scheduleTask: [ 
			self application defer: [ 
				listPresenter model: itemsModel.
				self updateTitle ] ] ]
]

{ #category : 'initialization' }
PulsarRepositoryCommitsView >> updateTitle [

	self withPanelWidgetDo: [ :aPanelWindow | 
		aPanelWindow title: ('Commits ({1})' format: { 
			(lastBranchSelected ifNil: [ self model ]) name truncateWithElipsisTo: 20 }) ]
]
