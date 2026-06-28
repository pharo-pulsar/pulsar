"
Left pane of the PulsarTestRunnerBrowser, displaying the test tree with three-state selection toggles.

Organized as: project root → test packages → test classes → test methods. Each node has an active/inactive toggle propagated through the branch.
"
Class {
	#name : 'PulsarTestRunnerTestsView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'mutex'
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
			name: 'Run Selected';
			iconName: 'testGreen';
			description: 'Run selected tests';
			shortcutKey: $r actionModifier;
			action: [ (PulsarTestRunnerActionContext on: self) doRunSelectedFor: self model ] ];
		addActionWith: [ :action | action
			name: 'Run All';
			iconName: 'testNotRun';
			description: 'Run all tests';
			shortcutKey: $r shift actionModifier;
			action: [ (PulsarTestRunnerActionContext on: self) doRunAllFor: self model ] ];
		addActionWith: [ :action | action
			name: 'Select All';
			iconName: 'checkboxSelected';
			description: 'Select all tests';
			action: [ self doSelectAll ] ];
		addActionWith: [ :action | action
			name: 'Deselect All';
			iconName: 'checkboxUnselected';
			description: 'Deselect all tests';
			action: [ self doDeselectAll ] ];
		addActionWith: [ :action | action
			name: 'Refresh';
			iconName: 'refresh';
			description: 'Refresh test tree';
			action: [ (PulsarTestRunnerActionContext on: self) doRefreshFor: self model ] ] ]
]

{ #category : 'private - actions' }
PulsarTestRunnerTestsView >> doDeselectAll [

	self model suites do: [ :each | each deselectAll ].
	self updatePresenter
]

{ #category : 'private - actions' }
PulsarTestRunnerTestsView >> doSelectAll [

	self model suites do: [ :each | each selectAll ].
	self updatePresenter
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> initialize [

	super initialize.
	mutex := Mutex new
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> initializePresenters [

	self addStyle: 'pulsarTestRunnerView'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #testRunner).

	listPresenter := self newEasyTreeListView
		                 addStyle: 'stTree';
		                 addStyle: 'pulsarTestRunnerTree';
		                 rowPresenterClass: PulsarTestRunnerTestRow;
		                 display: [ :aNode | aNode description ];
		                 children: [ :aNode | aNode children ];
		                 actions: (self actions actionsFor: #nodeActions);
		                 yourself
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarTestRunFinished send: #updatePresenter to: self
]

{ #category : 'initialization' }
PulsarTestRunnerTestsView >> updatePresenter [

	self model ifNil: [ ^ self ].
	listPresenter roots: self model suites
]
