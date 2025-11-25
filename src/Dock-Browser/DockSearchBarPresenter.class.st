"
A search bar presenter to search text inside a code/text presenter.
The model of this presenter is the code/text presenter on which it acts and cannot be set *after* its construction.
"
Class {
	#name : 'DockSearchBarPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'backwardButton',
		'forwardButton',
		'closeButton',
		'searchTextPresenter',
		'replaceTextPresenter',
		'showing',
		'caseSensitiveButton',
		'wholeWordButton',
		'regexButton',
		'replaceToolbarPresenter',
		'searchToolbarPresenter',
		'toggleReplaceButton',
		'replaceButton',
		'replaceAllButton',
		'highlightAllButton',
		'connected',
		'searchCountPresenter'
	],
	#classVars : [
		'LastSearch'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'layout' }
DockSearchBarPresenter >> buildReplaceToolbar [

	^ self newPresenter 
		layout: (SpBoxLayout newHorizontal
			hAlignStart;
			vAlignCenter;
			add: replaceButton;
			add: replaceAllButton;
			yourself);
		yourself
]

{ #category : 'layout' }
DockSearchBarPresenter >> buildSearchToolbar [

	^ self newPresenter 
		layout: (SpBoxLayout newHorizontal
			hAlignStart;
			vAlignCenter;
			add: forwardButton;
			add: backwardButton;
			add: highlightAllButton;
			add: caseSensitiveButton;
			add: wholeWordButton;
			"add: regexButton;"
			add: closeButton;
			yourself);
		yourself
]

{ #category : 'private' }
DockSearchBarPresenter >> closeIfNoPresenterHasFocus [

	"in fact this is not true, once opened, the search tool stays open until the user dismisses it"

	"showing ifTrue: [ ^ self ].

	(self presenters anySatisfy: [ :each | each hasKeyboardFocus ]) 
		ifTrue: [ ^ self ].
	
	self doClose"
]

{ #category : 'initialization' }
DockSearchBarPresenter >> connectPresenters [ 

	self model 
		addShortcutWith: [ :action | action 
			shortcutKey: $f mod1;
			action: [ self doTogglePresent ] ].

	searchTextPresenter 
		whenTextChangedDo: [ :aString | self doSearch: aString ]; 
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey escape asKeyCombination | $f mod1;
			action: [ self doClose ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: $r mod1;
			action: [ toggleReplaceButton state: toggleReplaceButton state not ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey enter asKeyCombination;
			action: [ self doSearchForward ] ].
			
	replaceTextPresenter 
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey escape asKeyCombination | $f mod1;
			action: [ self doClose ] ];
		addShortcutWith: [ :action | action 
			shortcutKey:  $r mod1;
			action: [ toggleReplaceButton state: toggleReplaceButton state not ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey enter asKeyCombination;
			action: [ self doReplace ] ].
		
	self eventHandler 
		whenFocusLostDo: [ self closeIfNoPresenterHasFocus ]
]

{ #category : 'api - focus' }
DockSearchBarPresenter >> defaultKeyboardFocus [

	^ searchTextPresenter
]

{ #category : 'layout' }
DockSearchBarPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: toggleReplaceButton expand: false;
		add: (SpGridLayout new 
			beColumnNotHomogeneous;
			columnSpacing: 0;
			rowSpacing: 0;
			column: 1 expand: true;
			column: 2 expand: false;
			build: [ :aBuilder | aBuilder 
				add: (SpOverlayLayout new 
						addOverlay: searchCountPresenter withConstraints: [ :c | c hAlignEnd; vAlignCenter ];
						child: searchTextPresenter;
						yourself); 	
					add: searchToolbarPresenter; nextRow;
				add: replaceTextPresenter; 	add: replaceToolbarPresenter ];
			yourself);
		yourself
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doClose [

	self isVisible ifFalse: [ ^ self ].

	self prepareSearchToClose.
	"reset replace button"
	toggleReplaceButton state: false.
	"hide myself"
	self hide.
	"restore focus to my caller"
	self model takeKeyboardFocus
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doPresent [ 

	self isVisible ifTrue: [ ^ self ].

	showing := true.
	[ 
		self application defer: [
			self prepareSearchToPresent.
			self show.
			self takeKeyboardFocus.
			searchTextPresenter selectAll ] ] 
	ensure: [
		showing := false ]
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doReplace [
	| text |

	text := replaceTextPresenter text.
	self model replaceSelectionWith: text
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doReplaceAll [
	| replaceString |

	replaceString := replaceTextPresenter text.
	self model replaceAllMatchesWith: replaceString
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doSearch: aString [

	self model searchText: aString.
	self updateCount
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doSearchBackward [

	self model searchBackward
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doSearchForward [

	self model searchForward
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doToggleCaseSensitive: aState [

	self model caseSensitive: aState.
	self updateSearch
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doToggleHighlightAll: aState [

	self model highlightSearchText: aState.
	self updateSearch
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doTogglePresent [ 

	self isVisible
		ifTrue: [ self doClose ]
		ifFalse: [ self doPresent ]
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doToggleRegex: aState [

	self model regex: aState.
	self updateSearch
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doToggleReplace: aState [

	self application defer: [
		replaceTextPresenter visible: aState.
		replaceToolbarPresenter visible: aState.
		toggleReplaceButton icon: (self iconNamed: (aState 
			ifTrue: [ 'chevron-down' ]
			ifFalse: [ 'chevron-right' ])).
		searchTextPresenter takeKeyboardFocus ]
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> doToggleWholeWord: aState [
	
	self model wholeWord: aState.
	self updateSearch
]

{ #category : 'initialization' }
DockSearchBarPresenter >> initialize [

	super initialize.
	showing := false
]

{ #category : 'initialization' }
DockSearchBarPresenter >> initializePresenters [

	self addStyle: 'dockSearchPanel'.
	
	toggleReplaceButton := self newToggleButton
		addStyle: 'flat';
		addStyle: 'buttonToggleSearch';
		icon: (self iconNamed: 'chevron-right');
		help: 'Toggle search replace activate';
		whenChangedDo: [ :state | self doToggleReplace: state ].

	self initializeSearch.
	self initializeReplace.
	
	self focusOrder: {
		searchTextPresenter.
		replaceTextPresenter.
	}. 

	self hide.
	
	
]

{ #category : 'initialization' }
DockSearchBarPresenter >> initializeReplace [
	
	self flag: #TODO. "enter on search text = replace next"
	replaceTextPresenter := self newTextInput
		placeholder: 'Replace';
 		yourself.
	
	replaceButton := self newButton
		addStyle: 'flat';
		icon: (self iconNamed: 'replace');
		help: 'Replace next occurrence';
		action: [ self doReplace ].
	
	replaceAllButton := self newButton
		addStyle: 'flat';
		icon: (self iconNamed: 'replace-all');
		help: 'Replace all occurrences';
		action: [ self doReplaceAll ].

	replaceToolbarPresenter := self buildReplaceToolbar.
	
	replaceTextPresenter hide.
	replaceToolbarPresenter hide.
]

{ #category : 'initialization' }
DockSearchBarPresenter >> initializeSearch [
	
	self flag: #TODO. "Add a history (with arrows) (history affects also replace if opened, but happens here)"
	
	searchTextPresenter := self newTextInput
		placeholder: 'Find';
 		yourself.
	
	searchCountPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		addStyle: 'count';
		yourself.
	
	forwardButton := self newButton
		addStyle: 'flat';
		help: 'Select next search match';
		icon: (self iconNamed: 'search-forward');
		action: [ self doSearchForward ].
		
	backwardButton := self newButton
		addStyle: 'flat';
		help: 'Select previous search match';
		icon: (self iconNamed: 'search-backward');
		action: [ self doSearchBackward ].
	
	highlightAllButton := self newToggleButton
		addStyle: 'flat';
		help: 'Highlight all occurrences of search string';
		icon: (self iconNamed: 'highlight-all');
		whenChangedDo: [ :state | self doToggleHighlightAll: state ].
		
	caseSensitiveButton := self newToggleButton
		addStyle: 'flat';
		help: 'Search case sensitive';
		icon: (self iconNamed: 'case-sensitive');
		whenChangedDo: [ :state | self doToggleCaseSensitive: state ].
	
	wholeWordButton := self newToggleButton
		addStyle: 'flat';
		help: 'Search whole word';
		icon: (self iconNamed: 'whole-word');
		whenChangedDo: [ :state | self doToggleWholeWord: state ].

	regexButton := self newToggleButton
		addStyle: 'flat';
		help: 'Search regex';
		icon: (self iconNamed: 'regex');
		whenChangedDo: [ :state | self doToggleRegex: state ].
	
	closeButton := self newButton
		addStyle: 'flat';
		help: 'Close search';
		icon: (self iconNamed: 'close');
		action: [ self doClose ].

	searchToolbarPresenter := self buildSearchToolbar
]

{ #category : 'accessing - model' }
DockSearchBarPresenter >> model: aModel [
	self error: 'model can''t be set after creation.'
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> prepareSearchToClose [

	self model endSearch.
	self model highlightSearchText: false
]

{ #category : 'initialization' }
DockSearchBarPresenter >> prepareSearchToPresent [

	self application defer: [
		self model
			highlightSearchText: highlightAllButton state;
			caseSensitive: caseSensitiveButton state;
			wholeWord: wholeWordButton state;
			regex: regexButton state.
		self doSearch: searchTextPresenter text ]
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> updateCount [
	| count |

	searchCountPresenter visible: highlightAllButton state.
	
	searchCountPresenter isVisible ifFalse: [ ^ self ].
	
	count := self model searchOccurrencesCount.
	searchCountPresenter label: (searchTextPresenter text 
		ifNotEmpty: [ 
			'{1} match{2}' format: { 
				count. 
				count = 1 ifTrue: [ '' ] ifFalse: [ 'es' ] } ]
		ifEmpty: [ '' ])
]

{ #category : 'initialization' }
DockSearchBarPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	self application defer: [
		self model
			highlightSearchText: highlightAllButton state;
			caseSensitive: caseSensitiveButton state;
			wholeWord: wholeWordButton state;
			regex: regexButton state.
		self doSearch: searchTextPresenter text ]
]

{ #category : 'private - actions' }
DockSearchBarPresenter >> updateSearch [

	self doSearch: searchTextPresenter text
]
