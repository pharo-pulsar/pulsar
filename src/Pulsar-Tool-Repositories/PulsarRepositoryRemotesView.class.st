Class {
	#name : 'PulsarRepositoryRemotesView',
	#superclass : 'PulsarCollectionView',
	#traits : 'PulsarTActionContainer',
	#classTraits : 'PulsarTActionContainer classTrait',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Remotes',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Remotes'
}

{ #category : 'defaults' }
PulsarRepositoryRemotesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 2;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRemotesView >> connectPresenters [

	"override as I do not have transmissions for now"
]

{ #category : 'layout' }
PulsarRepositoryRemotesView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - definitions' }
PulsarRepositoryRemotesView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #actions with: [ :group | group 
		addActionWith: [ :action | action 
			name: 'Add remote';
			iconName: #add;
			description: 'Add a remote';
			action: [ self doAddRemote ] ] ].
			
	aBuilder addGroup: #contextActions with: [ :group | group 
		addGroup: #critical with: [ :dangerGroup | dangerGroup
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				dynamicName: [ 'Remove {1}' format: { self selectedItemName } ];
				description: 'Add a remote';
				actionEnabled: [ self hasSelectedItem ];
				action: [ self doRemoveSelectedRemote ] ] ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryRemotesView >> doAddRemote [
	| remotePresenter |

	remotePresenter := self instantiate: PulsarRepositoryRemoteDialog.
	remotePresenter beForAddition.
	
	(remotePresenter asModalWindow
		owner: self window;
		open) 
		isOk ifFalse: [ ^ self ].
	
	self scheduleJob: [
		self model 
			addRemote: remotePresenter name
			url: remotePresenter url.
		self updatePresenter ]

]

{ #category : 'private - actions' }
PulsarRepositoryRemotesView >> doClose [
	
	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - actions' }
PulsarRepositoryRemotesView >> doRemoveRemote: aRemote [

	(self application newConfirm
		title: 'Remove remote';
		message: ('Remove ''{1}'' remote?' format: { aRemote name });
		acceptLabel: 'Remove';
		openModalWithParent: self window)
			ifFalse: [ ^ self ].
	
	self scheduleTask: [
		(self model newRemoveRemoteActionFor: aRemote)
			executeWithContext: self.
		self updatePresenter ]
]

{ #category : 'private - actions' }
PulsarRepositoryRemotesView >> doRemoveSelectedRemote [

	self doRemoveRemote: self selectedItem
]

{ #category : 'initialization' }
PulsarRepositoryRemotesView >> initializePresenters [

	self addStyle: 'pulsarRepositoryRemotes'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter 
		actions: (self actions actionsFor: #actions);
		addPresenter: (self newToolbar 
			beIcons;
			add: (self newButton
				addStyle: 'flat';
				icon: (self iconNamed: 'close');
				help: 'Close remotes';
				action: [ self doClose ];
				yourself);
			yourself).

	listPresenter := self newTable
		addStyle: 'stList';
		addStyle: 'pulsarRemoteList';
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'URL' evaluated: #url);
		actions: self actions;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRemotesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Remotes'
]

{ #category : 'initialization' }
PulsarRepositoryRemotesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self scheduleJob: [
		| remotes |
		remotes := self model remotes.
		listPresenter items: remotes ]
]
