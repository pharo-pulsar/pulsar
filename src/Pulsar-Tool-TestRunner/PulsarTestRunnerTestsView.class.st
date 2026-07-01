"
Left pane of the PulsarTestRunnerBrowser, displaying the test tree with three-state selection toggles.

Organized as: project root → test packages → test classes → test methods. Each node has an active/inactive toggle propagated through the branch.
"
Class {
	#name : 'PulsarTestRunnerTestsView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'expansions'
	],
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'defaults' }
PulsarTestRunnerTestsView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> connectPresenters [

	super connectPresenters.

	listPresenter outputSelectionPort 
		transmitDo: [ :anEntity | self entitySelected: anEntity ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self entityActivated: anEntity ]
]

{ #category : 'layout' }
PulsarTestRunnerTestsView >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPresenter expand: false;
		  add: listPresenter;
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

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> initialize [

	expansions := Set new.
	super initialize
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> initializePresenters [

	self addStyle: 'pulsarTestRunnerView'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #testRunner).

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'pulsarTestRunnerTree';
		rowPresenterClass: PulsarTestRunnerTestsRow;
		whenRowPresenterInstantiatedDo: [ :aRowPresenter | 
			aRowPresenter whenActivatedDo: [ :aModel | self doRun: aModel ] ];
		display: [ :aNode | aNode description ];
		children: [ :aNode | aNode children ];
		actions: (self actions actionsFor: #nodeActions);
		whenExpandChangedDo: [ :ann | 
			self registerExpansion: ann item expand: ann expanded ];
		yourself
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

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self scheduleTask: [
		| selected |
	
		self application defer: [ 
			selected := listPresenter selectedItem.
			listPresenter roots: self model suites.
			expansions do: [ :each | listPresenter expandItem: each ].
			listPresenter selectItem: selected ] ]
]
