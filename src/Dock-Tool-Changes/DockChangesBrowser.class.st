Class {
	#name : 'DockChangesBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'logListPresenter',
		'entryListPresenter',
		'entryPatchPresenter'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'initialization' }
DockChangesBrowser >> connectPresenters [

	logListPresenter 
		transmitTo: entryListPresenter
		transform: [ :aFileReference | self model entriesOnReference: aFileReference ]
]

{ #category : 'layout' }
DockChangesBrowser >> defaultLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 200;
		add: logListPresenter;
		add: (SpPanedLayout newVertical 
			add: entryListPresenter;
			add: entryPatchPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
DockChangesBrowser >> initialize [

	model := DockChangesModel new.
	super initialize
]

{ #category : 'initialization' }
DockChangesBrowser >> initializePresenters [

	self addStyle: 'dockChanges'.

	logListPresenter := self newEasyListView
		display: [ :each | each modificationTime epiceaBrowsersAsString ];
		yourself.
	entryListPresenter := self newEasyListView
		rowPresenterClass: DockEntryRowPresenter;
		yourself.
	entryPatchPresenter := self instantiate: SpPatchPresenter
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
