Class {
	#name : 'PulsarChangesBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'logListPresenter',
		'sessionPresenter'
	],
	#category : 'Pulsar-Tool-Changes',
	#package : 'Pulsar-Tool-Changes'
}

{ #category : 'initialization' }
PulsarChangesBrowser >> connectPresenters [

	logListPresenter 
		transmitDo: [ :aFileReference | self updateSessionWith: aFileReference ]
]

{ #category : 'layout' }
PulsarChangesBrowser >> defaultLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 200;
		add: logListPresenter;
		add: sessionPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarChangesBrowser >> initialize [

	model := PulsarChangesModel new.
	super initialize
]

{ #category : 'initialization' }
PulsarChangesBrowser >> initializePresenters [

	self addStyle: 'pulsarBrowser'.
	self addStyle: 'pulsarChanges'.

	"list of logs"
	logListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :each | each modificationTime epiceaBrowsersAsString ];
		yourself.

	sessionPresenter := self instantiate: PulsarChangesSessionPresenter
]

{ #category : 'initialization' }
PulsarChangesBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Changes Log'
]

{ #category : 'initialization' }
PulsarChangesBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	logListPresenter 
		items: self model logFiles;
		selectFirst
]

{ #category : 'initialization' }
PulsarChangesBrowser >> updateSessionWith: aFileReference [
		
	sessionPresenter model: (aFileReference ifNotNil: [ PulsarChangesSessionModel newFileReference: aFileReference ])
]
