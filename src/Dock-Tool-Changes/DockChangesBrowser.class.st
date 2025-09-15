Class {
	#name : 'DockChangesBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'logListPresenter',
		'entryListPresenter',
		'entryPatchPresenter',
		'sessionHeaderPresenter'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'initialization' }
DockChangesBrowser >> connectPresenters [

	logListPresenter 
		transmitDo: [ :aFileReference | self updateSessionWith: aFileReference ].
		
	entryListPresenter 
		transmitDo: [ :anEntry | self updatePatchWith: anEntry ]
]

{ #category : 'layout' }
DockChangesBrowser >> defaultLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 200;
		add: logListPresenter;
		add: (SpPanedLayout newVertical 
			add: (SpBoxLayout newVertical 
				add: sessionHeaderPresenter expand: false;
				add: entryListPresenter;
				yourself);
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

	self addStyle: 'dockBrowser'.
	self addStyle: 'dockChanges'.

	logListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :each | each modificationTime epiceaBrowsersAsString ];
		yourself.
	sessionHeaderPresenter := self newLabel 
		addStyle: 'dockHeader';
		yourself.
		
	entryListPresenter := self newEasyListView
		addStyle: 'stList';
		beMultipleSelection;
		rowPresenterClass: DockEntryRowPresenter;
		yourself.
		
	entryPatchPresenter := self instantiate: DockChangesEntryPatchPresenter
]

{ #category : 'initialization' }
DockChangesBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Changes Log'
]

{ #category : 'initialization' }
DockChangesBrowser >> updatePatchWith: aCollectionOfEntries [
	| entry |
	
	(aCollectionOfEntries isEmpty or: [ aCollectionOfEntries size > 1 ]) 
		ifTrue: [ 
			entryPatchPresenter beEmpty.
			^ self ].
	
	entryPatchPresenter model: aCollectionOfEntries first
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

	aFileReference ifNil: [
		sessionHeaderPresenter label: 'No session selected'.
		entryListPresenter items: #().
		^ self ].
	
	sessionHeaderPresenter label: 'Session: ', aFileReference modificationTime epiceaBrowsersAsString. 
	entryListPresenter items: (self model entriesOnReference: aFileReference)
]
