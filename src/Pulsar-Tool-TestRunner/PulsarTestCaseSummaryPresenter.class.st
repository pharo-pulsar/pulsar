Class {
	#name : 'PulsarTestCaseSummaryPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : 'Pulsar-Tool-TestRunner-View',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'View'
}

{ #category : 'layout' }
PulsarTestCaseSummaryPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		hAlignStart;
		vAlignCenter;
		yourself
]

{ #category : 'initialization' }
PulsarTestCaseSummaryPresenter >> initializePresenters [

	self addStyle: 'testResultSummary'
]

{ #category : 'private' }
PulsarTestCaseSummaryPresenter >> newResultStyle: aStyle icon: anIconName label: aName count: aNumber [
	| iconName |

	iconName := anIconName.
	aNumber = 0 ifTrue: [ iconName := iconName, '.neutral' ].
	^ self newPresenter
		addStyle: aStyle;
		layout: (SpBoxLayout newHorizontal
			add: (self newImage image: (self iconNamed: iconName));
			add: (self newLabel label: ('{1} {2}' format: { aNumber. aName }));
			yourself);
		yourself
]

{ #category : 'private' }
PulsarTestCaseSummaryPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	self application defer: [ 
		self layout 
			removeAll;
			add: (self
				newResultStyle: 'passed' 
				icon: 'testResultPass' 
				label: 'passed' 
				count: self model passCount);
			add: (self newLabel label: '·');
			add: (self 
				newResultStyle: 'failure' 
				icon: 'testResultFailure' 
				label: 'failures' 
				count: self model failCount);
			add: (self newLabel label: '·');
			add: (self 
				newResultStyle: 'errors' 
				icon: 'testResultError' 
				label: 'errors' 
				count: self model errorCount) ]
]
