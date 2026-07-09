"
Left pane of the PulsarTestRunnerBrowser, displaying the test tree with three-state selection toggles.

Organized as: project root → test packages → test classes → test methods. Each node has an active/inactive toggle propagated through the branch.
"
Class {
	#name : 'PulsarTestRunnerTestsView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'expansions',
		'mutex',
		'filterInputPresenter',
		'filterListPresenter'
	],
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'defaults' }
PulsarTestRunnerTestsView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
]

{ #category : 'connecting' }
PulsarTestRunnerTestsView >> connectPresenters [

	super connectPresenters.

	listPresenter outputSelectionPort 
		transmitDo: [ :anEntity | self entitySelected: anEntity ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self entityActivated: anEntity ].

	filterListPresenter outputSelectionPort 
		transmitDo: [ :anEntity | self entitySelected: anEntity ].
	filterListPresenter outputActivationPort 
		transmitDo: [ :anEntity | self entityActivated: anEntity ].
	
	filterInputPresenter whenTextChangedDo: [ :aString | 
		self updateFilterWith: aString ]
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPresenter expand: false;
		  add: listPresenter;
		  add: filterListPresenter;
		  add: filterInputPresenter expand: false;
		  yourself
]

{ #category : 'private - definitions' }
PulsarTestRunnerTestsView >> defineTestRunnerActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #testRunner with: [ :group | group
		priority: 100;
		name: 'Tests';
		beDisplayedAsGroup;
		addActionWith: [ :action | action
			name: 'Run All';
			iconName: 'run-test';
			description: 'Run all tests';
			shortcutKey: $r shift actionModifier;
			action: [ (PulsarTestRunnerActionContext on: self) doRunAllFor: self model ] ];
		addActionWith: [ :action | action
			name: 'Refresh';
			iconName: 'refresh';
			description: 'Refresh test tree';
			action: [ (PulsarTestRunnerActionContext on: self) doRefreshFor: self model ] ] ]
]

{ #category : 'private - actions' }
PulsarTestRunnerTestsView >> doRun: aModel [

	aModel runOn: (PulsarTestRunnerActionContext on: self)
]

{ #category : 'filtering' }
PulsarTestRunnerTestsView >> filterStartingSize [

	^ 3
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> initialize [

	expansions := Set new.
	mutex := Mutex new.
	super initialize
]

{ #category : 'filtering' }
PulsarTestRunnerTestsView >> initializeFilter [

	filterListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'pulsarTestRunnerFilterList';
		display: [ :aModel | aModel description ];
		rowPresenterClass: PulsarTestRunnerTestsRow;
				actions: (self actions actionsFor: #nodeActions);
		yourself.

	filterListPresenter hide.

	filterInputPresenter := self newTextInput
		addStyle: 'flat';
		placeholder: ('Filter ({1}+ characters)...' format: { self filterStartingSize });
		yourself
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> initializePresenters [

	self addStyle: 'pulsarTestRunnerView'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #testRunner).

	self initializeTree.
	self initializeFilter
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> initializeTree [

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'pulsarTestRunnerTree';
		rowPresenterClass: PulsarTestRunnerTestsRow;
		whenRowPresenterInstantiatedDo: [ :aRowPresenter |
			aRowPresenter whenActivatedDo: [ :aModel | self doRun: aModel ] ];
		display: [ :aNode | aNode description ];
		children: [ :aNode | aNode children ];
		actions: (self actions actionsFor: #nodeActions);
		whenExpandChangedDo: [ :ann | self registerExpansion: ann item expand: ann expanded ];
		yourself.

]

{ #category : 'private' }
PulsarTestRunnerTestsView >> registerExpansion: item expand: expand [

	expand 
		ifTrue: [ expansions add: item ]
		ifFalse: [ expansions remove: item ifAbsent: [] ]
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarTestRunStarted send: #updatePresenter to: self
]

{ #category : 'filtering' }
PulsarTestRunnerTestsView >> updateFilterWith: aString [

	(aString isEmptyOrNil or: [ aString size < self filterStartingSize ]) ifTrue: [
		self application defer: [
			listPresenter show.
			filterListPresenter hide ].
		^ self ].

	self scheduleTask: [
		| items |
		items := self model filterWith: aString.
		self application defer: [
			listPresenter hide.
			filterListPresenter show.
			filterListPresenter items: items ] ]
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> updatePresenter [

	self model ifNil: [ ^ self ].

	self scheduleTask: [
			| selected |
			self application defer: [
					selected := self model consumePendingSelection ifNil: [ listPresenter selectedItem ].
					listPresenter roots: self model suites.
					expansions do: [ :each | listPresenter expandItem: each ].
					selected ifNotNil: [
							selected parentModel ifNotNil: [ :parent | listPresenter expandItem: parent ].
							listPresenter selectItem: selected ] ] ]
]
