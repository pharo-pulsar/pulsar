Class {
	#name : 'PulsarTestCaseDetailPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'iconPresenter',
		'statusPresenter',
		'descriptionPresenter',
		'durationPresenter'
	],
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'layout' }
PulsarTestCaseDetailPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
				hAlignStart;
				add: iconPresenter expand: false;
				add: statusPresenter;
				yourself)
			expand: false;
		add: descriptionPresenter expand: false;
		add: durationPresenter expand: false;
		yourself
]

{ #category : 'private' }
PulsarTestCaseDetailPresenter >> iconForResult: aSymbol [

	aSymbol ifNil: [ ^ self iconNamed: 'testResultPass' ].
	aSymbol == #failure ifTrue: [ ^ self iconNamed: 'testResultFailure' ].
	aSymbol == #error ifTrue: [ ^ self iconNamed: 'testResultError' ].
	^ self iconNamed: 'test-not-run'
]

{ #category : 'initialization' }
PulsarTestCaseDetailPresenter >> initializePresenters [

	self addStyle: 'testCaseDetail'.

	iconPresenter := self newImage.

	statusPresenter := self newLabel
		                   addStyle: 'detailStatus';
		                   yourself.

	descriptionPresenter := self newLabel
		                        addStyle: 'detailInfo';
		                        yourself.

	durationPresenter := self newLabel
		                     addStyle: 'detailDuration';
		                     yourself
]

{ #category : 'private' }
PulsarTestCaseDetailPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	iconPresenter image: (self iconForResult: self model result).
	statusPresenter label: self model statusLabel.
	descriptionPresenter label: self model fullDescription.
	durationPresenter label: ('Duration: {1} ms' format: { (self model duration ifNil: [ 0 ]) })
]
