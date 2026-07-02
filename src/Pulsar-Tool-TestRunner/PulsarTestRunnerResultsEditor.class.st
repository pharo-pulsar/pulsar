"
Right pane of the PulsarTestRunnerBrowser, displaying test run results.

Top: summary bar with passed/failures/errors/skipped counts.
Middle: results tree grouped by status → class → method.
Bottom: detail pane showing stack trace for a selected failure.
"
Class {
	#name : 'PulsarTestRunnerResultsEditor',
	#superclass : 'PulsarBaseView',
	#instVars : [
		'summaryPresenter',
		'listPresenter',
		'detailPresenter',
		'toolbarPresenter',
		'togglePassedButtonPresenter',
		'toggleFailureButtonPresenter',
		'toggleErrorButtonPresenter',
		'filterStatus'
	],
	#classVars : [
		'FilterStatus'
	],
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'private' }
PulsarTestRunnerResultsEditor class >> createFilterStatus [
	"pairs statustype -> filtered."
	^ SmallDictionary newFromPairs: {
		#passed. 	true.
		#failure. 	false.
		#error. 		false.
	}
]

{ #category : 'defaults' }
PulsarTestRunnerResultsEditor class >> defaultPanelPosition [

	^ SpPanelPosition centerArea
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor class >> filterStatus [
	
	^ FilterStatus ifNil: [  
		FilterStatus := self createFilterStatus ]
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor class >> filterStatusAt: aSymbol [
	
	^ self filterStatus at: aSymbol
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor class >> filterStatusAt: aSymbol put: aBoolean [
	
	^ self filterStatus 
		at: aSymbol 
		put: aBoolean
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> addVisibilityToolbar [
	
	(togglePassedButtonPresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: 'testResultPass.neutral');
		help: 'Toggle visibility (hide/show) of tests that pass';
		state: (self isHide: #passed);
		whenChangedDo: [ :state | self toggleCase: #passed to: state ];
		yourself.
	
	(toggleFailureButtonPresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: 'testResultFailure.neutral');
		help: 'Toggle visibility (hide/show) of tests with failures';
		state: (self isHide: #failure);
		whenChangedDo: [ :state | self toggleCase: #failure to: state ];
		yourself.

	(toggleErrorButtonPresenter := self newToggleButton)
		addStyle: 'flat';
		icon: (self iconNamed: 'testResultError.neutral');
		help: 'Toggle visibility (hide/show) of tests with errors';
		state: (self isHide: #error);
		whenChangedDo: [ :state | self toggleCase: #error to: state ];
		yourself.
	
	toolbarPresenter addPresenter: (self newToolbar
		displayMode: self application toolbarDisplayMode;
		add: togglePassedButtonPresenter;
		add: toggleFailureButtonPresenter;
		add: toggleErrorButtonPresenter;
		yourself)
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> applyFilterTo: aCollection [
	| results |
	
	results := aCollection.
	(self isHide: #passed) ifTrue: [ results := results reject: [ :each | each status = #passed ] ].
	(self isHide: #failure) ifTrue: [ results := results reject: [ :each | each status = #failure ] ].
	(self isHide: #error) ifTrue: [ results := results reject: [ :each | each status = #error ] ].
	
	^ results
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> connectPresenters [

	super connectPresenters.

	listPresenter transmitDo: [ :aCase | 
		detailPresenter model: aCase; show ].

	listPresenter outputActivationPort transmitDo: [ :aCase | self notifyActivateEntity: aCase ]
]

{ #category : 'layout' }
PulsarTestRunnerResultsEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPresenter expand: false;
		  add: summaryPresenter expand: false;
		  add: listPresenter;
		  add: detailPresenter expand: false;
		  yourself
]

{ #category : 'private -actions' }
PulsarTestRunnerResultsEditor >> doDebug: aModel [

	aModel debugOn: ((PulsarTestRunnerActionContext on: self)
		model: self model testRunnerModel;
		yourself)
]

{ #category : 'private -actions' }
PulsarTestRunnerResultsEditor >> doRun: aModel [

	aModel runOn: ((PulsarTestRunnerActionContext on: self)
		model: self model testRunnerModel;
		yourself)
]

{ #category : 'events' }
PulsarTestRunnerResultsEditor >> eventTestRunFinished: ann [

	ann value ifNil: [ ^ self ].
	
	self model: ann value
]

{ #category : 'events' }
PulsarTestRunnerResultsEditor >> eventTestRunStarted: ann [

	ann value ifNil: [ ^ self ].
	
	self model: ann value
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> initializePanelWidget: aPanelWidgetPresenter [

	super initializePanelWidget: aPanelWidgetPresenter.
	aPanelWidgetPresenter
		pinned: true;
		windowIcon: (self iconNamed: 'testResults')
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> initializePresenters [

	self addStyle: 'pulsarTestResultsEditor'.

	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter title: 'No case selected'.
	self addVisibilityToolbar.

	summaryPresenter := self instantiate: PulsarTestCaseSummaryPresenter.

	listPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :aCase | aCase description ];
		"displayIcon: [ :aCase | self iconNamed: (self model iconNameFor: aCase) ];"
		rowPresenterClass: PulsarTestRunnerTestsRow;
		whenRowPresenterInstantiatedDo: [ :aRowPresenter | 
			aRowPresenter whenActivatedDo: [ :aCase | self doDebug: aCase ] ];
		yourself.

	detailPresenter := self instantiate: PulsarTestCaseDetailPresenter.
	detailPresenter hide
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: 'Results'
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> isHide: aSymbol [

	^ self class filterStatusAt: aSymbol
]

{ #category : 'private - announcing' }
PulsarTestRunnerResultsEditor >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarTestRunStarted send: #eventTestRunStarted: to: self.
	self announcer when: PulsarTestExecutionChanged send: #updatePresenter to: self
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> toggleCase: aSymbol to: aState [
	
	self class filterStatusAt: aSymbol put: aState.
	self updatePresenter
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	toolbarPresenter title: self model name.
	summaryPresenter model: self model.
	listPresenter items: (self applyFilterTo: self model entries)
]
