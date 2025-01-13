Class {
	#name : 'DockSpotter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTNotificationCenter',
	#classTraits : 'SpTModel classTrait + DockTNotificationCenter classTrait',
	#instVars : [
		'searchPresenter',
		'resultListPresenter',
		'runner',
		'emptyPresenter'
	],
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
DockSpotter class >> defaultExtent [

	^ 700@350
]

{ #category : 'private - actions' }
DockSpotter >> acceptSelection [

	self withWindowDo: [ :aWindow | aWindow close ].
	resultListPresenter selectedItem 
		ifNotNil: [ :anEntry | anEntry accept: self ]
]

{ #category : 'initialization' }
DockSpotter >> connectPresenters [

	searchPresenter 
		whenTextChangedDo: [ :aString | self doSearch: aString ];
		whenSubmitDo: [ :aString | self acceptSelection ].
	resultListPresenter whenActivatedDo: [ :aSelection | self acceptSelection ]
]

{ #category : 'layout' }
DockSpotter >> defaultLayout [

	^ SpOverlayLayout new 
		child: (SpBoxLayout newVertical
			add: searchPresenter expand: false;
			add: resultListPresenter);
		addOverlay: emptyPresenter withConstraints: [ :c | c vAlignCenter; hAlignCenter ];
		yourself
]

{ #category : 'private - actions' }
DockSpotter >> doSearch: aString [

	runner schedule: [ 
		self udpdateResultListWith: (self model candidatesFor: aString) ]
]

{ #category : 'initialization' }
DockSpotter >> initialize [
	
	super initialize.
	self flag: #TODO. "I need probably a 'keep just last task' worker"
	runner := TKTWorker new start
]

{ #category : 'initialization' }
DockSpotter >> initializeDialogWindow: aDialogWindowPresenter [

]

{ #category : 'initialization' }
DockSpotter >> initializePresenters [

	self addStyle: 'dockSpotter'.
	
	emptyPresenter := self newLabel 
		addStyle: 'dim';
		label: 'No results yet...';
		yourself.
	
	searchPresenter := self newSearchInput
		placeholder: 'Search for classes, methods...';
		yourself.
	 
	resultListPresenter := self newEasyListView
		rowPresenterClass: DockSpotterRow;
		yourself
]

{ #category : 'initialization' }
DockSpotter >> initializeWindow: aWindowPresenter [
	
	self flag: #TODO. "Do I really want to let decorations out? This is not equal to morphic..."
	aWindowPresenter 
		initialExtent: self class defaultExtent;
		withoutDecorations.
	
]

{ #category : 'initialization' }
DockSpotter >> udpdateResultListWith: aCollection [
	
	"use defer to ensure UI loop"
	self application defer: [
	
		emptyPresenter visible: aCollection isEmpty.
		resultListPresenter updateItemsKeepingSelection: aCollection.
		(resultListPresenter selectedItem isNil 
			and: [ aCollection isNotEmpty ])
			ifTrue: [ resultListPresenter selectFirst ] ]
]

{ #category : 'visiting' }
DockSpotter >> visitClassEntry: aClassEntry [ 
	
	self notifyActivateEntity: (PvClassModel 
		newEnvironment: self model environmentModel
		entity: aClassEntry content)
]

{ #category : 'visiting' }
DockSpotter >> visitMethodEntry: aClassEntry [ 
	
	self notifyActivateEntity: (PvMethodModel 
		newEnvironment: self model environmentModel
		entity: aClassEntry content)
]
