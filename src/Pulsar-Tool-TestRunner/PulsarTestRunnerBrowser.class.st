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
	
	aBuilder addGroup: #testRunnerGlobal with: [ :group | group
		beDisplayedAsGroup;
		addActionWith: [ :action | action
			name: 'Run Selected';
			iconName: 'testGreen';
			description: 'Run selected tests';
			shortcutKey: $r actionModifier;
			action: [ self doRunSelected ] ];
		addActionWith: [ :action | action
			name: 'Run All';
			iconName: 'testNotRun';
			description: 'Run all tests';
			shortcutKey: $r shift actionModifier;
			action: [ self doRunAll ] ];
		addActionWith: [ :action | action
			name: 'Refresh';
			iconName: 'refresh';
			description: 'Refresh test tree';
			action: [ self doRefresh ] ] ]
]

{ #category : 'private - actions' }
PulsarTestRunnerBrowser >> doRefresh [

	self model refresh.
	self presentersDo: [ :eachPresenter |
		(eachPresenter presenter isKindOf: PulsarTestRunnerTestsView) ifTrue: [ eachPresenter presenter updatePresenter ] ]
]

{ #category : 'private - actions' }
PulsarTestRunnerBrowser >> doRunAll [

	self scheduleJob: [ :aJob |
			| result |
			aJob
				title: 'Running all tests';
				min: 0;
				max: 1;
				progress: 1.
			result := self model runAllTests.
			result ifNotNil: [ self announce: (PulsarTestRunFinished newValue: result) ] ]
]

{ #category : 'private - actions' }
PulsarTestRunnerBrowser >> doRunSelected [

	self scheduleJob: [ :aJob |
			| result |
			aJob
				title: 'Running selected tests';
				min: 0;
				max: 1;
				progress: 1.
			result := self model runSelectedTests.
			result ifNotNil: [ self announce: (PulsarTestRunFinished newValue: result) ] ]
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
