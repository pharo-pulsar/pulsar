"
A search bar presenter to search text inside a code/text presenter.
The model of this presenter is the code/text presenter on which it acts and cannot be set *after* its construction.
"
Class {
	#name : 'PulsarSearchBarPresenter',
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
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'layout' }
PulsarSearchBarPresenter >> buildReplaceToolbar [

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
PulsarSearchBarPresenter >> buildSearchToolbar [

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
PulsarSearchBarPresenter >> closeIfNoPresenterHasFocus [

	"in fact this is not true, once opened, the search tool stays open until the user dismisses it"

	"showing ifTrue: [ ^ self ].

	(self presenters anySatisfy: [ :each | each hasKeyboardFocus ]) 
		ifTrue: [ ^ self ].
	
	self doClose"
]

{ #category : 'initialization' }
PulsarSearchBarPresenter >> connectPresenters [ 

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
PulsarSearchBarPresenter >> defaultKeyboardFocus [

	^ searchTextPresenter
]

{ #category : 'layout' }
PulsarSearchBarPresenter >> defaultLayout [

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
PulsarSearchBarPresenter >> doClose [

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
PulsarSearchBarPresenter >> doPresent [ 

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
PulsarSearchBarPresenter >> doReplace [
	| text |

	text := replaceTextPresenter text.
	self model replaceSelectionWith: text
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doReplaceAll [
	| replaceString |

	replaceString := replaceTextPresenter text.
	self model replaceAllMatchesWith: replaceString
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doSearch: aString [

	self model searchText: aString.
	self updateCount
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doSearchBackward [

	self model searchBackward
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doSearchForward [

	self model searchForward
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doToggleCaseSensitive: aState [

	self model caseSensitive: aState.
	self updateSearch
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doToggleHighlightAll: aState [

	self model highlightSearchText: aState.
	self updateSearch
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doTogglePresent [ 

	self isVisible
		ifTrue: [ self doClose ]
		ifFalse: [ self doPresent ]
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doToggleRegex: aState [

	self model regex: aState.
	self updateSearch
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doToggleReplace: aState [

	self application defer: [
		replaceTextPresenter visible: aState.
		replaceToolbarPresenter visible: aState.
		toggleReplaceButton icon: (self iconNamed: (aState 
			ifTrue: [ 'chevron-down' ]
			ifFalse: [ 'chevron-right' ])).
		searchTextPresenter takeKeyboardFocus ]
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> doToggleWholeWord: aState [
	
	self model wholeWord: aState.
	self updateSearch
]

{ #category : 'initialization' }
PulsarSearchBarPresenter >> initialize [

	super initialize.
	showing := false
]

{ #category : 'initialization' }
PulsarSearchBarPresenter >> initializePresenters [

	self addStyle: 'pulsarSearchPanel'.
	
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

	self hide
]

{ #category : 'initialization' }
PulsarSearchBarPresenter >> initializeReplace [
	
	self flag: #TODO. "enter on search text = replace next"
	replaceTextPresenter := self newTextInput
		placeholder: 'Replace';
 		yourself.
	
	replaceButton := self newButton
		addStyle: 'flat';
		addStyle: 'tinyFont';
		label: 'Replace';
		help: 'Replace next occurrence';
		action: [ self doReplace ].
	
	replaceAllButton := self newButton
		addStyle: 'flat';
		addStyle: 'tinyFont';
		label: 'Replace All';
		help: 'Replace all occurrences';
		action: [ self doReplaceAll ].

	replaceToolbarPresenter := self buildReplaceToolbar.
	
	replaceTextPresenter hide.
	replaceToolbarPresenter hide
]

{ #category : 'initialization' }
PulsarSearchBarPresenter >> initializeSearch [
	
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
PulsarSearchBarPresenter >> model: aModel [
	self error: 'model can''t be set after creation.'
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> prepareSearchToClose [

	self model endSearch.
	self model highlightSearchText: false
]

{ #category : 'initialization' }
PulsarSearchBarPresenter >> prepareSearchToPresent [

	self application defer: [
		self model
			highlightSearchText: highlightAllButton state;
			caseSensitive: caseSensitiveButton state;
			wholeWord: wholeWordButton state;
			regex: regexButton state.
		self doSearch: searchTextPresenter text ]
]

{ #category : 'private - actions' }
PulsarSearchBarPresenter >> updateCount [
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
PulsarSearchBarPresenter >> updatePresenter [

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
PulsarSearchBarPresenter >> updateSearch [

	self doSearch: searchTextPresenter text
]
