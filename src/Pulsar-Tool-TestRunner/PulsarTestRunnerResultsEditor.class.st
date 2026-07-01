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

	listPresenter transmitDo: [ :aCase | detailPresenter model: aCase ].

	listPresenter outputActivationPort transmitDo: [ :aCase | self notifyActivateEntity: aCase ]
]

{ #category : 'layout' }
PulsarTestRunnerResultsEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: summaryPresenter expand: false;
		  add: listPresenter;
		  add: detailPresenter expand: false;
		  yourself
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

	summaryPresenter := self newLabel.
	summaryPresenter label: 'No results yet.'.

	listPresenter := self newEasyListView
		                 addStyle: 'stList';
		                 display: [ :aCase | aCase description ];
		                 displayIcon: [ :aCase | self iconNamed: (self model iconNameFor: aCase) ];
		                 yourself.

	detailPresenter := self instantiate: PulsarTestCaseDetailPresenter
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: 'Results'
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
PulsarTestRunnerResultsEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	summaryPresenter label: self model summary.
	listPresenter items: self model entries
]
