"
Row presenter for the test runner tree, displaying a checkbox, icon, and label for each test node. Matches the PulsarRepositoryChangeRow pattern.
"
Class {
	#name : 'PulsarTestRunnerTestsRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'checkBoxPresenter',
		'labelPresenter',
		'imagePresenter'
	],
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'initialization' }
PulsarTestRunnerTestsRow >> connectPresenters [

	checkBoxPresenter whenActivatedDo: [ self model toggleActiveInBranch ]
]

{ #category : 'layout' }
PulsarTestRunnerTestsRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: checkBoxPresenter expand: false;
		  add: imagePresenter expand: false;
		  add: labelPresenter;
		  yourself
]

{ #category : 'initialization' }
PulsarTestRunnerTestsRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarTestRunnerRow'.

	checkBoxPresenter := self newCheckBox.
	imagePresenter := self newImage.
	labelPresenter := self newLabel
]

{ #category : 'accessing - model' }
PulsarTestRunnerTestsRow >> model: aTestNode [

	self model ifNotNil: [ self model resetStateChangedAction ].
	super model: aTestNode.
	aTestNode whenStateChangedDo: [ :aValue | self updateActiveStatus: aValue ]
]

{ #category : 'initialization' }
PulsarTestRunnerTestsRow >> updateActiveStatus: aBoolean [

	checkBoxPresenter state: aBoolean
]

{ #category : 'initialization' }
PulsarTestRunnerTestsRow >> updatePresenter [

	self model ifNil: [ ^ self ].

	checkBoxPresenter state: self model isActive.
	imagePresenter image: (self iconNamed: self model iconName).
	labelPresenter label: self model description
]
