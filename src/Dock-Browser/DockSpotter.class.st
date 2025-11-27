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
		'activePresenter',
		'tabLayout',
		'editorsContext',
		'toolsContext',
		'environmentContext',
		'searchService',
		'lastSearchText',
		'waitingSearchText'
	],
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
DockSpotter class >> defaultExtent [

	^ 600@450
]

{ #category : 'private - actions' }
DockSpotter >> acceptSelection [
	| item |

	"I take the selected item first because closing the window can destroy 
	 the selection."
	item := activePresenter selectedItem.
	self withWindowDo: [ :aWindow | aWindow close ].
	item ifNotNil: [ :anEntry | anEntry accept: self ]
]

{ #category : 'initialization' }
DockSpotter >> connectPresenters [

	searchPresenter 
		whenTextChangedDo: [ :newText | waitingSearchText := newText ];
		whenSubmitDo: [ :aString | self acceptSelection ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey down asKeyCombination;
			action: [ self giveFocusToResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey right asKeyCombination actionModifier;
			action: [ self giveFocusToNextResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey left asKeyCombination actionModifier;
			action: [ self giveFocusToPreviousResultList ] ].
	
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
			child: ((tabLayout := SpTabLayout new) 
				add: resultListPresenter label: 'Environment';
				add: editorListPresenter label: 'Editors';
				add: toolListPresenter label: 'Commands';
				whenTabSelectedDo: [ :ann | self tabActivated: ann presenter ];
				yourself);
			addOverlay: emptyPresenter withConstraints: [ :c | c vAlignCenter; hAlignCenter ];
			yourself);
		yourself
]

{ #category : 'private - actions' }
DockSpotter >> doSearch: aString [
	
	"actually, this event can arrive even after close (because of how service works)"
	runner ifNil: [ ^ self ].
	"clean all possible pending tasks (this is *a bit* better, but still annoying :("
	runner purge.
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
		self udpdateResultListWith: candidates ]
]

{ #category : 'private' }
DockSpotter >> editorsContext [

	^ editorsContext ifNil: [ 
		editorsContext := DockSpotterSearchContext searchEditors
			browser: self owner root;
			yourself ]
]

{ #category : 'private' }
DockSpotter >> ensureSearchService [
		
	searchService ifNotNil: [ 
		searchService isRunning ifFalse: [ searchService restart ].
		^ searchService ].
	
	searchService := TKTParameterizableService new.
	searchService name: 'DockSpotter service: ', UUID new asString.
	searchService stepDelay: 100 milliSeconds.
	searchService step: [ self processSearch ].
	searchService start.
	
	^ searchService
]

{ #category : 'private' }
DockSpotter >> environmentContext [

	^ environmentContext ifNil: [ 
		environmentContext := DockSpotterSearchContext searchEnvironment
			browser: self owner window;
			yourself ]
]

{ #category : 'private' }
DockSpotter >> giveFocusToNextResultList [
	| nextPresenter |

	nextPresenter := tabLayout children last = activePresenter 
		ifTrue: [ tabLayout children first ]
		ifFalse: [ tabLayout children after: activePresenter ].
		
	tabLayout select: nextPresenter
]

{ #category : 'private' }
DockSpotter >> giveFocusToPreviousResultList [
	| prevPresenter |

	prevPresenter := tabLayout children first = activePresenter 
		ifTrue: [ tabLayout children last ]
		ifFalse: [ tabLayout children before: activePresenter ].
		
	tabLayout select: prevPresenter
]

{ #category : 'private' }
DockSpotter >> giveFocusToResultList [

	activePresenter takeKeyboardFocus
]

{ #category : 'accessing' }
DockSpotter >> initialOption: anOptionSymbol [

	self layout. "ensure layout exists"
	anOptionSymbol = #environment ifTrue: [ "nothing to do, original is 1 by default" ^ self ].
	anOptionSymbol = #windows ifTrue: [ tabLayout selectIndex: 2. ^ self ].
	anOptionSymbol = #commands ifTrue: [ tabLayout selectIndex: 3. ^ self ].
	
	self error: 'Should not arrive here'
]

{ #category : 'initialization' }
DockSpotter >> initialize [
	
	super initialize.
	runner := DockWorker new 
		inTool: self class;
		start
]

{ #category : 'initialization' }
DockSpotter >> initializeDialogWindow: aDialogWindowPresenter [

]

{ #category : 'initialization' }
DockSpotter >> initializePresenters [

	self addStyle: 'stSpotter'.
	self addStyle: 'dockSpotter'.

	emptyPresenter := self newLabel 
		addStyle: 'dim';
		label: 'No results yet...';
		yourself.

	searchPresenter := self newSearchInput
		addStyle: 'stSpotterSearch';
		yourself.

	resultListPresenter := self newResultList.
	editorListPresenter := self newResultList.
	toolListPresenter := self newResultList
]

{ #category : 'initialization' }
DockSpotter >> initializeWindow: aWindowPresenter [
	
	aWindowPresenter 
		initialExtent: self class defaultExtent;
		withoutDecorations;
		whenClosedDo: [ self windowClosed ];
		centered
]

{ #category : 'initialization' }
DockSpotter >> newResultList [

	^ self newEasyListView
		addStyle: 'stList';
		addStyle: 'stSpotterSearch';
		rowPresenterClass: DockSpotterRow;
		yourself
]

{ #category : 'private - announcing' }
DockSpotter >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity realModel newActivationAnnouncement
]

{ #category : 'private' }
DockSpotter >> processSearch [
	
	waitingSearchText = lastSearchText ifTrue: [ ^ self ].
	
	lastSearchText := waitingSearchText.
	self doSearch: lastSearchText
]

{ #category : 'private' }
DockSpotter >> selectedContext [

	activePresenter = editorListPresenter ifTrue: [ ^ self editorsContext ].
	activePresenter = toolListPresenter ifTrue: [ ^ self toolsContext ].
	
	^  self environmentContext
]

{ #category : 'private' }
DockSpotter >> tabActivated: aPresenter [
	
	activePresenter = aPresenter ifTrue: [ ^ self ].
	
	activePresenter := aPresenter.
	activePresenter ifNotNil: [
		self updateSearchPlaceHolder.
		lastSearchText := nil.
		waitingSearchText := searchPresenter text.
		self ensureSearchService ]
]

{ #category : 'private' }
DockSpotter >> toolsContext [

	^ toolsContext ifNil: [ 
		toolsContext := DockSpotterSearchContext searchTools
			browser: self owner window;
			yourself ]
]

{ #category : 'initialization' }
DockSpotter >> udpdateResultListWith: aCollection [
	| selected |
	
	self application defer: [
		selected := activePresenter selectedItem.
		emptyPresenter visible: aCollection isEmpty.
		activePresenter contentView disableActivationDuring: [
			activePresenter contentView disableSelectionDuring: [
				activePresenter items: aCollection ] ].
		aCollection ifNotEmpty: [
			selected 
				ifNotNil: [ activePresenter selectItem: selected ]
				ifNil: [ activePresenter selectFirst ] ] ]
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

{ #category : 'visiting' }
DockSpotter >> visitPanelEntry: anEntry [ 
	
	anEntry doEvaluate
]

{ #category : 'private' }
DockSpotter >> windowClosed [

	searchService ifNotNil: [ 
		searchService stop.
		searchService := nil ].
	runner stop.
	runner := nil
]
