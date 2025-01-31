Class {
	#name : 'DockSpotter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTNotificationCenter',
	#classTraits : 'SpTModel classTrait + DockTNotificationCenter classTrait',
	#instVars : [
		'searchPresenter',
		'resultListPresenter',
		'runner',
		'emptyPresenter',
		'editorListPresenter',
		'toolListPresenter',
		'activePresenter'
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
	activePresenter selectedItem 
		ifNotNil: [ :anEntry | anEntry accept: self ]
]

{ #category : 'initialization' }
DockSpotter >> connectPresenters [

	searchPresenter 
		whenTextChangedDo: [ :aString | self doSearch: aString ];
		whenSubmitDo: [ :aString | self acceptSelection ].
	resultListPresenter whenActivatedDo: [ :aSelection | self acceptSelection ].
	editorListPresenter whenActivatedDo: [ :aSelection | self acceptSelection ].
	toolListPresenter whenActivatedDo: [ :aSelection | self acceptSelection ]
]

{ #category : 'layout' }
DockSpotter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: searchPresenter expand: false;
		add: (SpOverlayLayout new 
			"child: resultListPresenter;"
			child: (SpTabLayout new 
				add: resultListPresenter label: 'Environment';
				add: editorListPresenter label: 'Editors';
				add: toolListPresenter label: 'Tools';
				whenTabSelectedDo: [ :ann | self tabActivated: ann presenter ];
				yourself);
			addOverlay: emptyPresenter withConstraints: [ :c | c vAlignCenter; hAlignCenter ];
			yourself)	;
		yourself
]

{ #category : 'private - actions' }
DockSpotter >> doSearch: aString [
	
	"clean all possible pending tasks (this is *a bit* better, but still annoying :("
	runner purge.
	runner isBusy ifTrue: [ 
		runner finalizer finalize.
		runner start ].
	"now schedule the last one"
	runner schedule: [ 
		| candidates |
		candidates := self model 
			candidatesFor: aString 
			inContext: self selectedContext.
		"just update the last result (empty runner means there are no more tasks) 
		 and since purge ensures there is always just one pending... this should 
		 work slightly better.
		 In anycase it feels smoother :)"
		runner isEmpty ifTrue: [
			self udpdateResultListWith: candidates ] ]
]

{ #category : 'initialization' }
DockSpotter >> initialize [
	
	super initialize.
	self flag: #TODO. "I need probably a 'keep just last task' worker"
	runner := DockWorker new 
		inTool: self class;
		start
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
	
	searchPresenter := self newSearchInput.
	 
	resultListPresenter := self newEasyListView
		addStyle: 'stList';
		rowPresenterClass: DockSpotterRow;
		yourself.

	editorListPresenter := self newEasyListView
		addStyle: 'stList';
		rowPresenterClass: DockSpotterRow;
		yourself.
		
	toolListPresenter := self newEasyListView
		addStyle: 'stList';
		rowPresenterClass: DockSpotterRow;
		yourself		
]

{ #category : 'initialization' }
DockSpotter >> initializeWindow: aWindowPresenter [
	
	aWindowPresenter 
		initialExtent: self class defaultExtent;
		withoutDecorations;
		whenClosedDo: [
			self windowClosed ]
]

{ #category : 'private' }
DockSpotter >> selectedContext [

	activePresenter = editorListPresenter ifTrue: [ ^ DockSpotterSearchContext searchEditors ].
	activePresenter = toolListPresenter ifTrue: [ ^  DockSpotterSearchContext searchTools ].
	
^  DockSpotterSearchContext searchEnvironment
]

{ #category : 'private' }
DockSpotter >> tabActivated: aPresenter [
	
	activePresenter = aPresenter ifTrue: [ ^ self ].
	
activePresenter := aPresenter.
	activePresenter ifNotNil: [
		self updateSearchPlaceHolder.
		self doSearch: searchPresenter text ]
]

{ #category : 'initialization' }
DockSpotter >> udpdateResultListWith: aCollection [
	
	"use defer to ensure UI loop"
	self application defer: [
		emptyPresenter visible: aCollection isEmpty.
		activePresenter updateItemsKeepingSelection: aCollection.
		(activePresenter selectedItem isNil 
			and: [ aCollection isNotEmpty ])
			ifTrue: [ resultListPresenter selectFirst ] ]
]

{ #category : 'initialization' }
DockSpotter >> updatePresenter [

	super updatePresenter
]

{ #category : 'initialization' }
DockSpotter >> updateSearchPlaceHolder [
	
	searchPresenter placeholder: self selectedContext searchPlaceholder
]

{ #category : 'visiting' }
DockSpotter >> visitClassEntry: aClassEntry [ 
	
	self notifyActivateEntity: (PvClassModel 
		newEnvironment: self model environmentModel
		entity: aClassEntry content)
]

{ #category : 'visiting' }
DockSpotter >> visitMenuEntry: anEntry [ 
	
	anEntry doEvaluate
]

{ #category : 'visiting' }
DockSpotter >> visitMethodEntry: aClassEntry [ 
	
	self notifyActivateEntity: (PvMethodModel 
		newEnvironment: self model environmentModel
		entity: aClassEntry content)
]

{ #category : 'private' }
DockSpotter >> windowClosed [

	runner stop
]
