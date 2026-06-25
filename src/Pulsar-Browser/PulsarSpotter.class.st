Class {
	#name : 'PulsarSpotter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait',
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
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
PulsarSpotter class >> defaultExtent [

	^ 600@450
]

{ #category : 'private - actions' }
PulsarSpotter >> acceptSelection [
	| item |

	"I take the selected item first because closing the window can destroy 
	 the selection."
	item := activePresenter selectedItem.
	self withWindowDo: [ :aWindow | aWindow close ].
	item ifNotNil: [ :anEntry | anEntry accept: self ]
]

{ #category : 'initialization' }
PulsarSpotter >> connectPresenters [

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
PulsarSpotter >> defaultLayout [

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
PulsarSpotter >> doSearch: aString [
	
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
PulsarSpotter >> editorsContext [

	^ editorsContext ifNil: [ 
		editorsContext := PulsarSpotterSearchContext searchEditors
			browser: self owner root;
			yourself ]
]

{ #category : 'private' }
PulsarSpotter >> ensureSearchService [
		
	searchService ifNotNil: [ 
		searchService isRunning ifFalse: [ searchService restart ].
		^ searchService ].
	
	searchService := TKTParameterizableService new.
	searchService name: 'PulsarSpotter service: ', UUID new asString.
	searchService stepDelay: 100 milliSeconds.
	searchService step: [ self processSearch ].
	searchService start.
	
	^ searchService
]

{ #category : 'private' }
PulsarSpotter >> environmentContext [

	^ environmentContext ifNil: [ 
		environmentContext := PulsarSpotterSearchContext searchEnvironment
			browser: self owner window;
			yourself ]
]

{ #category : 'private' }
PulsarSpotter >> giveFocusToNextResultList [
	| nextPresenter |

	nextPresenter := tabLayout children last = activePresenter 
		ifTrue: [ tabLayout children first ]
		ifFalse: [ tabLayout children after: activePresenter ].
		
	tabLayout select: nextPresenter
]

{ #category : 'private' }
PulsarSpotter >> giveFocusToPreviousResultList [
	| prevPresenter |

	prevPresenter := tabLayout children first = activePresenter 
		ifTrue: [ tabLayout children last ]
		ifFalse: [ tabLayout children before: activePresenter ].
		
	tabLayout select: prevPresenter
]

{ #category : 'private' }
PulsarSpotter >> giveFocusToResultList [

	activePresenter takeKeyboardFocus
]

{ #category : 'accessing' }
PulsarSpotter >> initialOption: anOptionSymbol [

	self layout. "ensure layout exists"
	anOptionSymbol = #environment ifTrue: [ "nothing to do, original is 1 by default" ^ self ].
	anOptionSymbol = #windows ifTrue: [ tabLayout selectIndex: 2. ^ self ].
	anOptionSymbol = #commands ifTrue: [ tabLayout selectIndex: 3. ^ self ].
	
	self error: 'Should not arrive here'
]

{ #category : 'initialization' }
PulsarSpotter >> initialize [
	
	super initialize.
	runner := PulsarWorker new 
		inTool: self class;
		start
]

{ #category : 'initialization' }
PulsarSpotter >> initializeDialogWindow: aDialogWindowPresenter [

]

{ #category : 'initialization' }
PulsarSpotter >> initializePresenters [

	self addStyle: 'stSpotter'.
	self addStyle: 'pulsarSpotter'.

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
PulsarSpotter >> initializeWindow: aWindowPresenter [
	
	aWindowPresenter 
		initialExtent: self class defaultExtent;
		withoutDecorations;
		whenClosedDo: [ self windowClosed ];
		centered
]

{ #category : 'initialization' }
PulsarSpotter >> newResultList [

	^ self newEasyListView
		addStyle: 'stList';
		addStyle: 'stSpotterSearch';
		rowPresenterClass: PulsarSpotterRow;
		yourself
]

{ #category : 'private - announcing' }
PulsarSpotter >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity realModel newActivationAnnouncement
]

{ #category : 'private' }
PulsarSpotter >> processSearch [
	
	waitingSearchText = lastSearchText ifTrue: [ ^ self ].
	
	lastSearchText := waitingSearchText.
	self doSearch: lastSearchText
]

{ #category : 'private' }
PulsarSpotter >> selectedContext [

	activePresenter = editorListPresenter ifTrue: [ ^ self editorsContext ].
	activePresenter = toolListPresenter ifTrue: [ ^ self toolsContext ].
	
	^  self environmentContext
]

{ #category : 'private' }
PulsarSpotter >> tabActivated: aPresenter [
	
	activePresenter = aPresenter ifTrue: [ ^ self ].
	
	activePresenter := aPresenter.
	activePresenter ifNotNil: [
		self updateSearchPlaceHolder.
		lastSearchText := nil.
		waitingSearchText := searchPresenter text.
		self ensureSearchService ]
]

{ #category : 'private' }
PulsarSpotter >> toolsContext [

	^ toolsContext ifNil: [
			  toolsContext := PulsarSpotterSearchContext searchTools
				                  browser: self owner root;
				                  yourself ]
]

{ #category : 'initialization' }
PulsarSpotter >> udpdateResultListWith: aCollection [
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
PulsarSpotter >> updatePresenter [

	super updatePresenter
]

{ #category : 'initialization' }
PulsarSpotter >> updateSearchPlaceHolder [
	
	searchPresenter placeholder: self selectedContext searchPlaceholder
]

{ #category : 'visiting' }
PulsarSpotter >> visitClassEntry: aClassEntry [ 
	
	self notifyActivateEntity: (PvClassModel 
		newEnvironment: self model environmentModel
		entity: aClassEntry content)
]

{ #category : 'visiting' }
PulsarSpotter >> visitMenuEntry: anEntry [ 
	
	anEntry doEvaluate
]

{ #category : 'visiting' }
PulsarSpotter >> visitMethodEntry: aClassEntry [ 
	
	self notifyActivateEntity: (PvMethodModel 
		newEnvironment: self model environmentModel
		entity: aClassEntry content)
]

{ #category : 'visiting' }
PulsarSpotter >> visitPackageEntry: aPackageEntry [

	self notifyActivateEntity: (PvPackageModel newEnvironment: self model environmentModel entity: aPackageEntry content)
]

{ #category : 'visiting' }
PulsarSpotter >> visitPanelEntry: anEntry [ 
	
	anEntry doEvaluate
]

{ #category : 'private' }
PulsarSpotter >> windowClosed [

	searchService ifNotNil: [ 
		searchService stop.
		searchService := nil ].
	runner stop.
	runner := nil
]
