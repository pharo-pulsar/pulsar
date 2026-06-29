"
Row presenter for the test runner tree, displaying an icon and label. Clicking the row runs the suite or case.
"
Class {
	#name : 'PulsarTestRunnerTestsRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'labelPresenter',
		'actionPresenter',
		'activateAction'
	],
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'private' }
PulsarTestRunnerTestsRow >> activate [

	activateAction ifNil: [ ^ self ].
	activateAction cull: self model
]

{ #category : 'layout' }
PulsarTestRunnerTestsRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: actionPresenter expand: false;
		  add: labelPresenter;
		  yourself
]

{ #category : 'initialization' }
PulsarTestRunnerTestsRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarTestRunnerRow'.

	actionPresenter := self newButton.
	actionPresenter
		addStyle: 'flat';
		addStyle: 'compact';
		addStyle: 'small';
		action: [ self activate ].
	
	labelPresenter := self newLabel
]

{ #category : 'initialization' }
PulsarTestRunnerTestsRow >> updatePresenter [

	self model ifNil: [ ^ self ].

	actionPresenter 
		help: ('Run {1} test' format: { self model description });
		icon: (self iconNamed: self model iconName).
	labelPresenter 
		help: self model statusDescription;
		label: self model description
]

{ #category : 'enumerating' }
PulsarTestRunnerTestsRow >> whenActivatedDo: aBlock [

	activateAction := aBlock
]
