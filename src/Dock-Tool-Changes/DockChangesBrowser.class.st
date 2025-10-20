Class {
	#name : 'DockChangesBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'logListPresenter',
		'sessionPresenter'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'initialization' }
DockChangesBrowser >> connectPresenters [

	logListPresenter 
		transmitDo: [ :aFileReference | self updateSessionWith: aFileReference ]
]

{ #category : 'layout' }
DockChangesBrowser >> defaultLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 200;
		add: logListPresenter;
		add: sessionPresenter;
		yourself
]

{ #category : 'initialization' }
DockChangesBrowser >> initialize [

	model := DockChangesModel new.
	super initialize
]

{ #category : 'initialization' }
DockChangesBrowser >> initializePresenters [

	self addStyle: 'dockBrowser'.
	self addStyle: 'dockChanges'.

	"list of logs"
	logListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :each | each modificationTime epiceaBrowsersAsString ];
		yourself.

	sessionPresenter := self instantiate: DockChangesSessionPresenter
]

{ #category : 'initialization' }
DockChangesBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Changes Log'
]

{ #category : 'initialization' }
DockChangesBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	logListPresenter 
		items: self model logFiles;
		selectFirst
]

{ #category : 'initialization' }
DockChangesBrowser >> updateSessionWith: aFileReference [
		
	sessionPresenter model: (aFileReference ifNotNil: [ DockChangesSessionModel newFileReference: aFileReference ])
]
