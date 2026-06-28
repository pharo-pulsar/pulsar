"
Row presenter for the test runner tree, displaying a checkbox, icon, and label for each test node. Matches the PulsarRepositoryChangeRow pattern.
"
Class {
	#name : 'PulsarTestRunnerTestRow',
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
PulsarTestRunnerTestRow >> connectPresenters [

	checkBoxPresenter whenActivatedDo: [
			(self model isKindOf: PulsarTestSuite)
				ifTrue: [ self model toggleAllSelection ]
				ifFalse: [ self model toggleSelection ] ]
]

{ #category : 'layout' }
PulsarTestRunnerTestRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: checkBoxPresenter expand: false;
		  add: imagePresenter expand: false;
		  add: labelPresenter;
		  yourself
]

{ #category : 'initialization' }
PulsarTestRunnerTestRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarTestRunnerRow'.

	checkBoxPresenter := self newCheckBox.
	imagePresenter := self newImage.
	labelPresenter := self newLabel
]

{ #category : 'accessing - model' }
PulsarTestRunnerTestRow >> model: aTestNode [

	super model: aTestNode.
	self updatePresenter
]

{ #category : 'initialization' }
PulsarTestRunnerTestRow >> updatePresenter [

	self model ifNil: [ ^ self ].

	checkBoxPresenter state: self model isSelected.
	imagePresenter image: (self iconNamed: self model iconName).
	labelPresenter label: self model description
]
