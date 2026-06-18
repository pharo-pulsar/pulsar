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
PulsarTestRunnerResultsEditor >> buildGroup: aName icon: anIcon items: anItemCollection [
	"Build a tree node for a status group (passed/failures/errors/skipped)."

	| groupNode classGroups |
	groupNode := PvTreeNodeModel new
		             name: ('{1} ({2})' format: {
						              aName.
						              anItemCollection size });
		             iconName: anIcon;
		             children: OrderedCollection new;
		             yourself.

	classGroups := anItemCollection groupedBy: [ :each | each testClassName ].
	classGroups keysAndValuesDo: [ :className :classItems |
			| classNode |
			classNode := PvTreeNodeModel new
				             name: className;
				             iconName: #testClass;
				             children: OrderedCollection new;
				             yourself.
			classItems do: [ :eachItem |
					| methodNode |
					methodNode := PvTreeNodeModel new
						              name: eachItem testSelector asString;
						              iconName: eachItem statusIconName;
						              children: #(  );
						              yourself.
					classNode children add: methodNode ].
			groupNode children add: classNode ].

	^ groupNode
]

{ #category : 'private' }
PulsarTestRunnerResultsEditor >> buildResultTreeFor: aResult [
	"Build a tree for display: status groups → classes → methods."

	| groups |
	groups := OrderedCollection new.

	aResult passedCount > 0 ifTrue: [ groups add: (self buildGroup: 'Passed' icon: #testPassed items: aResult passed) ].
	aResult failureCount > 0 ifTrue: [ groups add: (self buildGroup: 'Failures' icon: #testFailure items: aResult failures) ].
	aResult errorCount > 0 ifTrue: [ groups add: (self buildGroup: 'Errors' icon: #testError items: aResult errors) ].
	aResult skippedCount > 0 ifTrue: [ groups add: (self buildGroup: 'Skipped' icon: #testNotRun items: aResult skipped) ].

	^ groups
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
	"Display detail text for an error/failure node."

	| text |
	text := ''.
	detailPresenter text: text
]

{ #category : 'events' }
PulsarTestRunnerResultsEditor >> eventTestRunFinished: ann [

	| result |
	result := ann value.
	result ifNil: [ ^ self ].
	self updateFromResult: result
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
PulsarTestRunnerResultsEditor >> updateFromResult: aResult [

	summaryPresenter label: aResult summaryString.
	resultsTree roots: (self buildResultTreeFor: aResult)
]
