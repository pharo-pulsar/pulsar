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
		'detailPresenter'
	],
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'defaults' }
PulsarTestRunnerResultsEditor class >> defaultPanelPosition [

	^ SpPanelPosition centerArea
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> connectPresenters [

	super connectPresenters.

	listPresenter outputSelectionPort transmitDo: [ :aCase | self detailTextFor: aCase ].
	listPresenter display: [ :eachCase | eachCase description ]
]

{ #category : 'layout' }
PulsarTestRunnerResultsEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: summaryPresenter expand: false;
		  add: (SpPanedLayout newTopToBottom
				   add: listPresenter;
				   add: detailPresenter;
				   yourself);
		  yourself
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> detailTextFor: aCase [

	aCase ifNil: [ ^ detailPresenter text: '' ].

	detailPresenter text: (String streamContents: [ :stream |
				 stream nextPutAll: 'Class: '.
				 stream nextPutAll: aCase testClass name.
				 stream cr.
				 stream nextPutAll: 'Selector: '.
				 stream nextPutAll: aCase testSelector.
				 stream cr.
				 stream nextPutAll: 'Status: '.
				 stream nextPutAll: (aCase result ifNil: [ 'passed' ]) ])
]

{ #category : 'events' }
PulsarTestRunnerResultsEditor >> eventTestRunFinished: ann [

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

	summaryPresenter := self newLabel.
	summaryPresenter label: 'No results yet.'.

	listPresenter := self newEasyListView
		addStyle: 'stList';
		yourself.

	detailPresenter := self newText.
	detailPresenter beNotEditable
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: 'Results'
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarTestRunStarted send: #eventTestRunFinished: to: self.
	self announcer when: PulsarTestExecutionChanged send: #updatePresenter to: self
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	summaryPresenter label: self model summary.
	listPresenter items: self model entries
]
