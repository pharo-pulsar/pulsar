"
A panel to show changes in the image (that can be commited and actionated in different ways)
"
Class {
	#name : 'DockRepositoryChangesView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
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

	super connectPresenters.
	
	listPresenter addActionWith: [ :action | action
		dynamicName: [ 
			listPresenter selectedItem 
				ifNotNil: [ :aNode | 
					'{1}elect {2}{3}' format: { 
						aNode isActive ifTrue: [ 'Uns' ] ifFalse: [ 'S' ].
						aNode description.
						aNode hasChildren ifTrue: [ ' branch' ] ifFalse: [ '' ] } ]
				ifNil: [ 'Toggle selection' ] ];
		shortcutKey: Character space asKeyCombination;
		actionEnabled: [ listPresenter selectedItem isNotNil ];
		action: [ self toggleActiveInBranch ] ].
		
	"since the list of gtk captures the space, I cannot use the shortcut added through the 
	 action, I am forced to add it like that."
	self flag: #TODO. "Consider putting support for space in Spec-Gtk, hacking it in the same 
	way we do with maybeInstallCROn:..."
	listPresenter eventHandler whenKeyDownDo: [ :anEvent | 
		(anEvent keyCharacter = Character space)
			ifTrue: [ self toggleActiveInBranch ].
		anEvent wasHandled: false ]
]

{ #category : 'layout' }
DockRepositoryChangesView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - definitions' }
DockRepositoryChangesView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #gitActions with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Commit';
			iconName: 'commit';
			description: 'Commit selected changes';
			shortcutKey: $c actionModifier;
			action: [ self doCommit ] ];
		addActionWith: [ :action | action 
			name: 'Discard';
			iconName: 'discard';
			description: 'Discard current changes and restore HEAD';
			action: [ self doDiscardChanges ] ];
		addActionWith: [ :action | action 
			name: 'Refresh';
			iconName: 'refresh';
			description: 'Refresh repository changes';
			action: [ self doRefresh ] ] ]
]

{ #category : 'private - definitions' }
DockRepositoryChangesView >> defineCollapseActionsOn: aBuilder [
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

{ #category : 'private - actions' }
DockRepositoryChangesView >> doCollapseAll [

	self scheduleJob: [
		listPresenter collapseAll ]
]

{ #category : 'private - actions' }
DockRepositoryChangesView >> doCollapseToClasses [

	self scheduleJob: [
		self application defer: [
			listPresenter collapseAll.
			listPresenter roots withIndexDo: [ :each :rootIndex | 
				each children withIndexDo: [ :each :packageIndex | 
					listPresenter expandPath: { rootIndex. packageIndex } ] ] ] ]
]

{ #category : 'private - actions' }
DockRepositoryChangesView >> doCollapseToPackages [

	self scheduleJob: [
		self application defer: [
			listPresenter collapseAll.
			listPresenter expandRoots ] ]
]

{ #category : 'private - actions' }
DockRepositoryChangesView >> doCommit [
	| commitPresenter dialog |

	commitPresenter := self instantiate: DockRepositoryCommitDialog.
	
	(dialog := commitPresenter asModalWindow) 
		owner: self window;
		open.
	dialog isOk ifFalse: [ ^ self ].
	
	commitPresenter message trimBoth ifEmpty: [ 
		(self application newConfirm
				title: 'Empty commit message';
				message: 'Your message is empty. Do you want to commit anyway?';
				acceptLabel: 'Commit';
				openModalWithParent: self window)
			ifFalse: [ ^ self ] ].
	
	self scheduleJob: [
		self model newCommitAction
			message: commitPresenter message;
			onSuccess: [ self repositoryModified ];
			executeWithContext: self ]
]

{ #category : 'private - actions' }
DockRepositoryChangesView >> doExpandAll [

	self scheduleJob: [
		listPresenter expandAll ]
]

{ #category : 'events' }
DockRepositoryChangesView >> eventRepositoryModified: ann [

	ann value = self model ifFalse: [ ^ self ].
	
	self model resetDiff.
	self updatePresenter
]

{ #category : 'initialization' }
DockRepositoryChangesView >> initializePresenters [

	self addStyle: 'dockRepositoryChangesView'.

	toolbarPresenter := self instantiate: DockToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #gitActions).
	toolbarPresenter addPresenterMenuButtonWith: (self actions actionsFor: #collapse).

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'dockRepositoryChangesTree';
		rowPresenterClass: DockRepositoryChangeRow;
		display: [ :aNode | aNode description ];
		children: [ :aNode | aNode children ];
		yourself
]

{ #category : 'initialization' }
DockRepositoryChangesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Changes'
]

{ #category : 'initialization' }
DockRepositoryChangesView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: DockRepositoryModified
		send: #eventRepositoryModified:
		to: self
]

{ #category : 'private' }
DockRepositoryChangesView >> repositoryModified [

	"inform to all windows, as all may have things to do"
	self application resendAnnouncement: (DockRepositoryModified newValue: self model)
]

{ #category : 'private' }
DockRepositoryChangesView >> toggleActiveInBranch [
	| aNode |

	aNode := listPresenter selectedItem.
	aNode ifNil: [ ^ self ].
	
	"defer as this may trigger a lot of updates at the same time"
	self application defer: [
		aNode toggleActiveInBranch ]
]

{ #category : 'initialization' }
DockRepositoryChangesView >> updatePresenter [
	
	self model ifNil: [ ^ self ].

	self application schedule: [
		self flag: #TODO. "I need to wait to let the window time to draw itself, otherwise 
		 this will be working in the middle and will have a long wait to show some repositories.
		 This should not happen, as this is in a taslk, but anyway... I need to review 
		 this later."
		100 milliSeconds wait.
		self scheduleJob: [
			| diff |
			"first calculate it in a scheduled task" 
			diff := self model diffNode.
			"then show it in UI thread"
			self application defer: [
				listPresenter 
					roots: diff children;
					expandAll ] ] ]
]
