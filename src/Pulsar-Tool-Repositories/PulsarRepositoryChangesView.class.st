"
A panel to show changes in the image (that can be commited and actionated in different ways)
"
Class {
	#name : 'PulsarRepositoryChangesView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'isDisplayed'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'defaults' }
PulsarRepositoryChangesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> connectPresenters [

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
			action: [ self doOpenRepositoryLocation ] ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doCollapseAll [

	self scheduleJob: [
		listPresenter collapseAll ]
]

{ #category : 'private - actions' }
PulsarRepositoryChangesView >> doCollapseToClasses [

	self scheduleJob: [
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
	| commitPresenter dialog |

	commitPresenter := self instantiate: PulsarRepositoryCommitDialog.
	
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
PulsarRepositoryChangesView >> doRefresh [

	self model resetDiff.
	self updatePresenter
]

{ #category : 'events' }
PulsarRepositoryChangesView >> eventRepositoryModified: ann [

	ann value = self model ifFalse: [ ^ self ].
	
	"not doing anything right now, I was updating the list here but in fact, 
	 I do not want to do that right now :P"
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
	toolbarPresenter actions: (self actions actionsFor: #gitActions).
	toolbarPresenter addPresenterMenuButtonWith: (self actions actionsForAll: #(collapse extra)).

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'pulsarRepositoryChangesTree';
		rowPresenterClass: PulsarRepositoryChangeRow;
		display: [ :aNode | aNode description ];
		children: [ :aNode | aNode children ];
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Changes'
]

{ #category : 'initialization' }
PulsarRepositoryChangesView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarRepositoryModified
		send: #eventRepositoryModified:
		to: self
]

{ #category : 'private' }
PulsarRepositoryChangesView >> repositoryModified [

	self model resetDiff.
	self updatePresenter.
	"inform to all windows, as all may have things to do"
	self application resendAnnouncement: (PulsarRepositoryModified newValue: self model).
	
	self takeKeyboardFocus
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
				expandAll ] ]
]
