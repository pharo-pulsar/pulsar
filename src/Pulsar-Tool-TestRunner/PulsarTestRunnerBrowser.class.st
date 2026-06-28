"
Dock window for the test runner, wrapping a PulsarTestRunnerModel.

Left pane: PulsarTestRunnerTestsView (test tree with toggles).
Right pane: PulsarTestRunnerResultsEditor (results summary + detail).
Dock actions: Run Selected Tests, Run All Tests, Refresh.
"
Class {
	#name : 'PulsarTestRunnerBrowser',
	#superclass : 'PulsarBaseBrowser',
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'private - definitions' }
PulsarTestRunnerBrowser >> defineTestRunnerGlobalActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #testRunnerGlobal with: [ :group |
			group
				beDisplayedAsGroup;
				addActionWith: [ :action |
						action
							name: 'Run Selected';
							iconName: 'testGreen';
							description: 'Run selected tests';
							shortcutKey: $r actionModifier;
							action: [ (PulsarTestRunnerActionContext on: self) doRunSelectedFor: self model ] ];
				addActionWith: [ :action |
						action
							name: 'Run All';
							iconName: 'testNotRun';
							description: 'Run all tests';
							shortcutKey: $r shift actionModifier;
							action: [ (PulsarTestRunnerActionContext on: self) doRunAllFor: self model ] ];
				addActionWith: [ :action |
						action
							name: 'Refresh';
							iconName: 'refresh';
							description: 'Refresh test tree';
							action: [ (PulsarTestRunnerActionContext on: self) doRefreshFor: self model ] ] ]
]

{ #category : 'initialization' }
PulsarTestRunnerBrowser >> initializeDefaultWorkspace [

	self
		startWidth: 400;
		endWidth: 500.
	self addPresenterClass: PulsarTestRunnerTestsView model: self model.
	self addPresenterClass: PulsarTestRunnerResultsEditor
]

{ #category : 'initialization' }
PulsarTestRunnerBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self model name
]

{ #category : 'initialization' }
PulsarTestRunnerBrowser >> initializeWorkspace [

	super initializeWorkspace.
	self startWidth: 400
]

{ #category : 'private - snapshot' }
PulsarTestRunnerBrowser >> snapshot [

	^ nil
]
