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

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> buildGroupNode: aSuite for: caseCollection label: aLabel [
	"Build a tree node for a group of cases from the same suite."

	| groupNode |
	groupNode := PvTreeNodeModel new
		             name: ('{1} - {2} ({3})' format: {
						              aSuite name.
						              aLabel.
						              caseCollection size });
		             iconName: #testNotRun;
		             children: OrderedCollection new;
		             yourself.
	caseCollection do: [ :eachCase |
			| methodNode |
			methodNode := PvTreeNodeModel new
				              name: eachCase testSelector;
				              iconName: eachCase iconName;
				              realModel: eachCase;
				              children: #(  );
				              yourself.
			groupNode children add: methodNode ].
	^ groupNode
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> buildResultTreeFor: aSuiteCollection [
	"Build a tree: failures group → class → method."

	| failureNodes errorNodes |
	failureNodes := OrderedCollection new.
	errorNodes := OrderedCollection new.

	aSuiteCollection do: [ :eachSuite |
			| failureCases errorCases |
			failureCases := eachSuite children select: [ :each | each result = #failure ].
			errorCases := eachSuite children select: [ :each | each result = #error ].
			failureCases ifNotEmpty: [ failureNodes add: (self buildGroupNode: eachSuite for: failureCases label: 'Failures') ].
			errorCases ifNotEmpty: [ errorNodes add: (self buildGroupNode: eachSuite for: errorCases label: 'Errors') ] ].

	^ failureNodes , errorNodes
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
	"self updateFromSuites: ann value suites"
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> initializePresenters [

	self addStyle: 'pulsarTestResultsEditor'.

	summaryPresenter := self newLabel.
	summaryPresenter label: 'No results yet.'.

	resultsTree := self newTreeTable
		               addColumn: (SpCompositeTableColumn new
				                title: 'Result';
				                addColumn: (SpImageTableColumn new
						                 evaluated: [ :each | each iconName ];
						                 width: 24;
						                 yourself);
				                addColumn: (SpStringTableColumn new
						                 evaluated: [ :each | each description ];
						                 yourself);
				                yourself);
		               children: [ :aNode | aNode children ];
		               yourself.

	detailPresenter := self newText.
	detailPresenter beNotEditable
]

{ #category : 'initialization' }
PulsarTestRunnerResultsEditor >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarTestRunFinished send: #eventTestRunFinished: to: self
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> updateFromSuites: aSuiteCollection [

	| passCount failCount errorCount |
	passCount := 0.
	failCount := 0.
	errorCount := 0.
	aSuiteCollection do: [ :eachSuite |
			eachSuite children do: [ :eachCase |
					eachCase result ifNil: [ passCount := passCount + 1 ] ifNotNil: [ :r |
							r = #failure
								ifTrue: [ failCount := failCount + 1 ]
								ifFalse: [ errorCount := errorCount + 1 ] ] ] ].
	summaryPresenter label: ('{1} passed, {2} failures, {3} errors' format: {
				 passCount.
				 failCount.
				 errorCount }).
	resultsTree roots: (self buildResultTreeFor: aSuiteCollection)
]
