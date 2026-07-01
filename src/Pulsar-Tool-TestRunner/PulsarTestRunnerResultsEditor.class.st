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
		'resultsTree',
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

	resultsTree whenSelectionChangedDo: [ :selection | selection ifNotNil: [ self detailTextFor: selection selectedItem ] ]
]

{ #category : 'layout' }
PulsarTestRunnerResultsEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: summaryPresenter expand: false;
		add: (SpPanedLayout newTopToBottom
			add: resultsTree;
			add: detailPresenter;
			yourself);
		yourself
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> detailTextFor: aNode [
	"Display detail text for the selected test case."
	| realCase |
	
	aNode ifNil: [ ^ self ].
	
	realCase := aNode realModel.
	(realCase isKindOf: PulsarTestCase) ifFalse: [ ^ detailPresenter text: '' ].
	detailPresenter text: (String streamContents: [ :stream |
				 stream nextPutAll: 'Class: '.
				 stream nextPutAll: realCase testClass name.
				 stream cr.
				 stream nextPutAll: 'Selector: '.
				 stream nextPutAll: realCase testSelector.
				 stream cr.
				 stream nextPutAll: 'Status: '.
				 stream nextPutAll: (realCase result ifNil: [ 'passed' ]) ])
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

	resultsTree := self newEasyTreeListView
		display: [ :aNode | aNode name ];
		displayIcon: [ :aNode | self iconNamed: aNode iconName ];
		children: [ :aNode | aNode children ];
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
	self announcer when: PulsarTestRunFinished send: #eventTestRunFinished: to: self
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	summaryPresenter label: self model summary.
	resultsTree 
		roots: self model resultNodes;
		expandRoots
]
