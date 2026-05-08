"
A panel to show changes in the image (that can be commited and actionated in different ways)
"
Class {
	#name : 'PulsarRepositoryChangesView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'toolbarActions',
		'isDisplayed'
	],
	#category : 'Pulsar-Tool-Repositories-View-Changes',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Changes'
}

{ #category : 'defaults' }
PulsarRepositoryChangesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> connectPresenters [

	super connectPresenters.
	
	listPresenter 
		addActionWith: [ :action | action
			priority: 0;
			dynamicName: [ 
				listPresenter selectedItem 
					ifNotNil: [ :aNode | 
						'{1} {2}{3}' format: { 
							aNode isActive ifTrue: [ 'Unselect' ] ifFalse: [ 'Select' ].
							aNode description.
							aNode hasChildren ifTrue: [ ' branch' ] ifFalse: [ '' ] } ]
					ifNil: [ 'Toggle selection' ] ];
			shortcutKey: Character space asKeyCombination;
			actionEnabled: [ listPresenter selectedItem isNotNil ];
			action: [ self toggleActiveInBranch ] ]
]

{ #category : 'layout' }
PulsarRepositoryChangesView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - definitions' }
PulsarRepositoryChangesView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #gitActions with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Commit';
			iconName: 'commit';
			description: 'Commit selected changes';
			shortcutKey: $c actionModifier;
			actionEnabled: [ self model canCommit ];
			action: [ self doCommit ] ];
		addActionWith: [ :action | action 
			name: 'Refresh';
			iconName: 'refresh';
			description: 'Refresh repository changes';
			action: [ self doRefresh ] ];
		addActionWith: [ :action | action 
			name: 'Toggle Lock';
			iconName: self model lockIconName;
			description: ('Toggle lock of {1}' format: { self model name }) ;
			action: [ self doToggleLockProject: action ] ] ]
]

{ #category : 'private - definitions' }
PulsarRepositoryChangesView >> defineCollapseActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #collapse with: [ :group | group 
		name: 'Collapse';
		addActionWith: [ :action | action 
			name: 'Collapse to classes';
			description: 'Collapse up to classes';
			action: [ self doCollapseToClasses ] ];
		addActionWith: [ :action | action 
			name: 'Collapse to packages';
			description: 'Collapse up to packages';
			action: [ self doCollapseToPackages ] ];
		addActionWith: [ :action | action 
			name: 'Collapse all';
			description: 'Collapse all';
			action: [ self doCollapseAll ] ];
		addActionWith: [ :action | action 
			name: 'Expand all';
			description: 'Expand all';
			action: [ self doExpandAll ] ] ]
]

{ #category : 'private - definitions' }
PulsarRepositoryChangesView >> defineExtraActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #extra with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Open repository location';
			description: 'Open repository location';
			action: [ self doOpenRepositoryLocation ] ];
		addActionWith: [ :action | action 
			name: 'Recalculate dirty packages';
			description: 'Recalculate disrty packages of this repository';
			action: [ self doRecalculateDirtyPackages ] ] ]
]

{ #category : 'private - definitions' }
PulsarRepositoryChangesView >> defineNodeActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #nodeActions with: [ :group | group
		beDisplayedAsGroup;
		addActionWith: [ :action | action
			priority: 101;
			name: 'Discard changes';
			iconName: 'discard';
			description: 'Discard changes in current node and restore repository HEAD';
			actionEnabled: [ self hasSelectedItem ];
			action: [ self doDiscardSelectedChanges ] ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doCollapseAll [

	self scheduleTask: [
		listPresenter collapseAll ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doCollapseToClasses [

	self scheduleTask: [
		self application defer: [
			listPresenter collapseAll.
			listPresenter roots withIndexDo: [ :each :rootIndex | 
				each children withIndexDo: [ :each :packageIndex | 
					listPresenter expandPath: { rootIndex. packageIndex } ] ] ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doCollapseToPackages [

	self scheduleJob: [
		self application defer: [
			listPresenter collapseAll.
			listPresenter expandRoots ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doCommit [

	(PulsarRepositoryActionContext on: self) doCommit: self model
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doDiscardSelectedChanges [
	| node |

	node := self selectedItem.
	node ifNil: [ ^ self ].
	
	self scheduleJob: [ :statusbar |
		statusbar pushMessage: ('Discarding {1}...' format: { node name }).
		self model discardChangesOn: node.
		self updatePresenter ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doExpandAll [

	self scheduleJob: [
		listPresenter expandAll ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doOpenRepositoryLocation [
	
	self model repositoryLocation
		ifNotNil: [ :aReference | WebBrowser openOn: aReference fullName ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doRecalculateDirtyPackages [
	
	self scheduleJob: [ :statusbar |
		statusbar pushMessage: ('Recalculating dirty packages of {1}...' format: { self model name }).
		self model recalculateDirtyChanges.
		self updatePresenter ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doRefresh [

	self model resetDiff.
	self updatePresenter
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doToggleLockProject: anAction [

	self scheduleJob: [
		self model toggleLock.
		anAction presenter icon: (self iconNamed: self model lockIconName) ]
]

{ #category : 'private' }
PulsarRepositoryChangesView >> entityActivated: aNode [

	aNode canBeActivated ifFalse: [ ^ self ].
	
	super entityActivated: aNode newEntityModel
]

{ #category : 'private' }
PulsarRepositoryChangesView >> entitySelected: ann [

	self updateToolbar.
	super entitySelected: ann	
]

{ #category : 'events' }
PulsarRepositoryChangesView >> eventRepositoryModified: ann [

	ann value = self model ifFalse: [ ^ self ].
	
	self model resetDiff.
	self updatePresenter
]

{ #category : 'testing' }
PulsarRepositoryChangesView >> hasSelectedNode [

	^ self selectedNode isNotNil
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> initialize [ 
	
	isDisplayed := false.
	super initialize.
	self whenDisplayDo: [
		isDisplayed := true.
		self updatePresenter ]
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> initializePresenters [

	self addStyle: 'pulsarRepositoryChangesView'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: self toolbarActions.
	toolbarPresenter addPresenterMenuButtonWith: (self actions actionsForAll: #(collapse extra)).

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'pulsarRepositoryChangesTree';
		rowPresenterClass: PulsarRepositoryChangeRow;
		display: [ :aNode | aNode description ];
		children: [ :aNode | aNode children ];
		actions: (SpActionGroup new  
			add: (self actions actionsFor: #nodeActions);
			addDynamicGroup: #dynamic with: [ :group | group add: self nodeActions ];
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Changes'
]

{ #category : 'private' }
PulsarRepositoryChangesView >> nodeActions [

	self hasSelectedNode ifFalse: [  ^ SpActionGroup new ].
	
	^ self selectedNode actionsWithContextOn: self
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarRepositoryModified
		send: #eventRepositoryModified:
		to: self
]

{ #category : 'testing' }
PulsarRepositoryChangesView >> selectedNode [

	^ listPresenter selectedItem
]

{ #category : 'private' }
PulsarRepositoryChangesView >> toggleActiveInBranch [
	| aNode |

	aNode := listPresenter selectedItem.
	aNode ifNil: [ ^ self ].
	
	"defer as this may trigger a lot of updates at the same time"
	self application defer: [
		aNode toggleActiveInBranch ]
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> toolbarActions [

	^ toolbarActions ifNil: [ 
		toolbarActions := (self actions actionsForAll: #(gitActions nodeActions)) ]
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> updatePresenter [
	
	self model ifNil: [ ^ self ].

	isDisplayed ifFalse: [ ^ self ].

	self scheduleJob: [
		| diff |
		"first calculate it in a scheduled task"
		diff := self model diffNode.
		"then show it in UI thread"
		self application defer: [
			listPresenter 
				roots: diff children;
				expandAll.
			self updateToolbar ] ]
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> updateToolbar [

	self toolbarActions allCommands do: [ :each | each updateEnableStatus ]
]
