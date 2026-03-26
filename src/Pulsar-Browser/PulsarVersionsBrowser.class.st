Class {
	#name : 'PulsarVersionsBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot + PulsarTActionContainer + PulsarTJobHandler + PulsarTTaskWorker',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait + PulsarTActionContainer classTrait + PulsarTJobHandler classTrait + PulsarTTaskWorker classTrait',
	#instVars : [
		'headerPresenter',
		'versionListPresenter',
		'patchPresenter',
		'sourcePresenter',
		'remoteInfoPresenter',
		'authorPresenter',
		'commitMessage',
		'commitId',
		'statusbar'
	],
	#category : 'Pulsar-Browser-Tool-Versions',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Versions'
}

{ #category : 'initialization' }
PulsarVersionsBrowser >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: PulsarPopoverControlBoxPresenter.
	controlsPresenter onPulsar: [ 
		self withPopoverDo: #dismiss.
		self notifyActivateEntity: self model ].
	controlsPresenter popoverActions: self versionActions.
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'adding' }
PulsarVersionsBrowser >> addStatusbarPresenter: aPresenter [
	"As the job will require to add a spinner, we need to implement this"

	statusbar addPrefix: aPresenter
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> addWindowControls [
	| controlsPresenter |

	controlsPresenter := self newToolbar
		beIcons;
		fillWith: self versionActions.
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> connectPresenters [
	
	versionListPresenter 
		transmitDo: [ :aDefinition | self updateSourceWith: aDefinition ].
	versionListPresenter outputActivationPort
		transmitDo: [ :aDefinition | self doRevert ]
]

{ #category : 'api - focus' }
PulsarVersionsBrowser >> defaultKeyboardFocus [

	^ versionListPresenter
]

{ #category : 'layout' }
PulsarVersionsBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: (SpBoxLayout newVertical 
			add: (SpPanedLayout newHorizontal
				positionOfSlider: 200;
				add: versionListPresenter;
				add: (SpTabLayout new 
					add: (SpScrollableLayout new 
							child: patchPresenter;
							withoutHScrollbar;
							yourself) 
						label: 'Patch';
					add: sourcePresenter label: 'Source';
					yourself);
				yourself);
			add: remoteInfoPresenter expand: false;
			yourself);
		add: statusbar expand: false;
		yourself
]

{ #category : 'private - definitions' }
PulsarVersionsBrowser >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #versionActions with: [ :group | 
		group addActionWith: [ :action | action 
			name: 'Revert';
			description: 'Revert to this version';
			iconName: 'accept';
			action: [ self doRevert ] ] ]
]

{ #category : 'private - definitions' }
PulsarVersionsBrowser >> defineExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #extraActions with: [ :group | group 
		addGroupWith: [ :fetchRepositoryGroup |
			| repositories |
		
			fetchRepositoryGroup
				name: 'Fetch remote versions';
				description: 'Fetch remote versions';
				iconName: 'fetch.neutral'.
			repositories := self model includingRepositories.
			repositories do: [ :each | 
				fetchRepositoryGroup addActionWith: [ :action | action 
					name: ('Fetch {1}' format: { each name });
					description: ('Fetch remote versions on {1}' format: { each name });
					iconName: 'fetch.neutral';
					actionEnabled: [ self hasRemoteVersions ];
					action: [ self doFetchRemoteVersionsCommand: action ] ] ].
			
			repositories size > 1 
				ifTrue: [ fetchRepositoryGroup beDisplayedAsSubMenu ]
				ifFalse: [ fetchRepositoryGroup beDisplayedAsGroup ] ] ]
]

{ #category : 'actions' }
PulsarVersionsBrowser >> doCopyCommitIdToClipboard [

	self application copyToClipboard: versionListPresenter selectedItem remoteCommit id
]

{ #category : 'private - actions' }
PulsarVersionsBrowser >> doFetchRemoteVersionsCommand: anAction [
	| repositories popover |
	
	repositories := self model includingRepositories.
	repositories size > 1 ifFalse: [
		self doFetchRemoteVersionsOnRepository: repositories anyOne.
		^ self ].

	self flag: #TODO. "I need a choose popover (like the request popover)" 
	popover := self newPopover.
	popover presenter: ((self instantiate: PulsarSelectDialog)
		items: repositories;
		display: #name;
		yourself).
	popover relativeTo: anAction presenter.
	popover popup
]

{ #category : 'private - actions' }
PulsarVersionsBrowser >> doFetchRemoteVersionsOnRepository: aRepositoryModel [

	self scheduleJob: [ :statusbar |
		statusbar pushMessage: ('Fetching versions on {1}...' format: { aRepositoryModel name }).
		self model fetchRemoteVersionsOn: aRepositoryModel.
		self updatePresenter.
		versionListPresenter takeKeyboardFocus ]
]

{ #category : 'actions' }
PulsarVersionsBrowser >> doRevert [
	"take selected version and apply it as current editor content"
	
	self  withPopoverDo: #dismiss.
	self model revertTo: versionListPresenter selectedItem
]

{ #category : 'private - testing' }
PulsarVersionsBrowser >> hasRemoteVersions [

	self model ifNotNil: [ ^ self model hasValidRemote ].
	
	^ false
]

{ #category : 'private' }
PulsarVersionsBrowser >> iconFor: aDefinition [

	^ aDefinition isFromRemoteCommit
		ifTrue: [ 'stored-code' ]
		ifFalse: [ 'blank' ]
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> initializeInfo [

	authorPresenter := self newLabel
		addStyle: 'author';
		yourself. 
	commitId := self newLabel
		addStyle: 'pill-commit';
		yourself.
	commitMessage := self newText
		beWrapWord;
		withoutScrollBars;
		propagateNaturalHeight: true;
		beNotEditable;
		yourself.

	remoteInfoPresenter := self newPresenter
		addStyle: 'info';
		layout: (SpBoxLayout newVertical
			add: commitMessage;
			add: (SpBoxLayout newHorizontal 
				hAlignStart;
				add: authorPresenter;
				"add: self newSeparator;"
				add: (SpBoxLayout newHorizontal 
					hAlignStart;
					add: commitId;
					add: (self newButton
						addStyle: 'flat';
						addStyle: 'small';
						addStyle: 'rows4';
						icon: (self iconNamed: 'copy-to-clipboard');
						help: 'Copy commit id to clipboard';
						action: [ self doCopyCommitIdToClipboard ];
						yourself);
					yourself);
				yourself);
			yourself);
		yourself.
	remoteInfoPresenter hide
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> initializePopover: aPopoverPresenter [
	
	self addPopoverControls.
	aPopoverPresenter 
		whenClosedDo: [ self windowClosed ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character arrowDown mod3;
			action: [ 
				self withPopoverDo: #dismiss.
				self notifyActivateEntity: self model ] ]
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> initializePresenters [

	self addStyle: 'pulsarFlyingBrowser'.
	self addStyle: 'pulsarVersionsFlyingBrowser'.
	
	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	versionListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :aDefinition | aDefinition timeStamp epiceaBrowsersAsString ];
		displayIcon: [ :aDefinition | self iconNamed: (self iconFor: aDefinition) ];
		actions: self versionActions;
		yourself.
	patchPresenter := self instantiate: SpPatchPresenter.
	patchPresenter addStyle: 'stCode'.
	
	sourcePresenter := self newCode
		editable: false;
		yourself.

	self initializeInfo.
	
	statusbar := self instantiate: SpPanelStatusbarPresenter
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model fullName;
		whenClosedDo: [ self windowClosed ].
		
	self addWindowControls
]

{ #category : 'private' }
PulsarVersionsBrowser >> normalizeAuthor: aString [
	| substrings |

	substrings := aString substrings: ' -_'.
	substrings size = 1 ifTrue: [ 
		substrings := substrings anyOne splitCamelCase ].
		
	^ ' ' join: (substrings collect: [ :each | each capitalized ])
]

{ #category : 'private - announcing' }
PulsarVersionsBrowser >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'removing' }
PulsarVersionsBrowser >> removeStatusbarPresenter: aPresenter [
	"As the job will require to add a spinner, we need to implement this"

	statusbar remove: aPresenter
]

{ #category : 'private' }
PulsarVersionsBrowser >> scheduleJob: aBlock [
	"schedule a task that will show the working spinner while it executes"

	self queueTask: [
		self jobStart.
		[ aBlock cull: statusbar ]
		ensure: [
			statusbar clearMessage.
			self jobEnd ] ]
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> updatePatchWith: aDefinition [
	| nextDefinition |
	nextDefinition := versionListPresenter items 
		after: aDefinition 
		ifAbsent: [ nil ].
		
	patchPresenter
		patchFrom: (nextDefinition 
			ifNotNil: [ nextDefinition sourceCode ]
			ifNil: [ '' ])
		to: aDefinition sourceCode
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [ 
		headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
			aBreadcrumb addSegment: self model title ].	
		versionListPresenter 
			items: self model versions; 
			selectFirst ]
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> updateSourceCodeWith: aDefinition [
		
	sourcePresenter 
		beForMethod: aDefinition method;
		text: aDefinition sourceCode
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> updateSourceWith: aDefinition [
	
	aDefinition ifNil: [ ^ self ].
	
	self updatePatchWith: aDefinition.
	self updateSourceCodeWith: aDefinition.
	
	aDefinition isFromRemoteCommit
		ifTrue: [
			commitId label: aDefinition remoteCommit shortId asString.
			authorPresenter label: (self normalizeAuthor: aDefinition author).
			commitMessage text: aDefinition remoteCommit comment trimRight.
			remoteInfoPresenter show ]
		ifFalse: [
			remoteInfoPresenter hide	]
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> versionActions [

	^ self actions actionsForAll: #(versionActions extraActions)
]

{ #category : 'private' }
PulsarVersionsBrowser >> windowClosed [

	logger trace.

	self purgeTaskWorker.
	self notifyEditorClosed
]
