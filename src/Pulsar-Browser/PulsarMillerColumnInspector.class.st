"
An inspector that shows multiple objects side by side in a miller list, each one in its own column, to be shown as a popover or docked in a browser.

Each column is a `PulsarSingleInspector` added dynamically with `addColumn:`. When more columns are shown than `visiblePanels`, a paginator built by `addPaginator` appears at the bottom and allows paging through the columns with shiftRange:.
"
Class {
	#name : 'PulsarMillerColumnInspector',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTEditor + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot + PulsarTPopover',
	#classTraits : 'SpTModel classTrait + PulsarTEditor classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait + PulsarTPopover classTrait',
	#instVars : [
		'headerPresenter',
		'millerList',
		'visiblePanels',
		'visibleRange',
		'panelsList',
		'paginatorPresenter',
		'incColumnsButtonPresenter',
		'visibleColumnsPresenter',
		'decColumnsButtonPresenter',
		'rangeLabelPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'defaults' }
PulsarMillerColumnInspector class >> defaultVisiblePanels [

	^ 2
]

{ #category : 'private' }
PulsarMillerColumnInspector >> addColumn: aModel [
	"this can be used just of activation (and first addition, of course :P)"
	| presenter |

	presenter := self 
		instantiate: PulsarSingleInspector 
		on: aModel.
	presenter notificationCenter: self notificationCenter.
	millerList children ifNotEmpty: [ 
		presenter whenClosedDo: [ :aPresenter | 
			self pageRemoved: aPresenter ] ].
	
	self application defer: [
		self addPresenterToList: presenter. 
		self updateVisibleColumns ]
]

{ #category : 'layout' }
PulsarMillerColumnInspector >> addPaginator [

	^ self newPresenter 
		layout: (SpBoxLayout newHorizontal
			vAlignCenter;
			add: (SpBoxLayout newHorizontal
				vAlignCenter;
				vAlignStart;
				add: rangeLabelPresenter;
				yourself);
			add: (SpBoxLayout newHorizontal
					hAlignCenter;
					add: (self newButton
						addStyle: 'flat';
						addStyle: 'circular';
						icon: (self iconNamed: 'chevron-left');
						action: [ self shiftRange: -1 ];
						yourself);
					add: (SpBoxLayout newVertical 
						vAlignCenter; 
						add: panelsList;
						yourself);
					add: (self newButton
						addStyle: 'flat';
						addStyle: 'circular';
						icon: (self iconNamed: 'chevron-right');
						action: [ self shiftRange: 1 ];
						yourself);
					yourself) 
				expand: false;
			add: (SpBoxLayout newHorizontal
				vAlignCenter;
				hAlignEnd;
				add: decColumnsButtonPresenter;
				add: visibleColumnsPresenter;
				add: incColumnsButtonPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> addPopoverControls [

	headerPresenter addPresenter: self newPopoverControlBoxPresenter
]

{ #category : 'private' }
PulsarMillerColumnInspector >> addPresenterToList: presenter [
	| lastPageName |

	self resetVisibleRange.
	
	lastPageName := self lastPageName.
	millerList add: presenter.
	self setIndexOfPage: presenter to: millerList children size.
	lastPageName ifNotNil: [
		presenter maybeSelectPageNamed: lastPageName ].
	presenter outputActivationPort
		transmitDo: [ :anObject | 
			self application defer: [ 
				self removePanelsFrom: presenter.
				self addColumn: anObject asPulsarInspectorModel ] ]
]

{ #category : 'accessing' }
PulsarMillerColumnInspector >> defaultKeyboardFocus [

	^ millerList children
		ifNotEmpty: [ :children | children last ]
		ifEmpty: [ super defaultKeyboardFocus ]
]

{ #category : 'layout' }
PulsarMillerColumnInspector >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: millerList;
		add: paginatorPresenter expand: false;
		yourself
]

{ #category : 'events' }
PulsarMillerColumnInspector >> eventSyntaxHighlightThemeChanged: ann [

	self traversePresentersDo: [ :each | each pulsarSyntaxHighlightThemeChanged ]
]

{ #category : 'events' }
PulsarMillerColumnInspector >> eventThemeChanged: ann [

	self traversePresentersDo: [ :each | each pulsarThemeChanged ]
]

{ #category : 'private' }
PulsarMillerColumnInspector >> indexOfPage: aPresenter [

	^ aPresenter propertyAt: #index
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> initialize [

	super initialize.
	self registerToEvents
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> initializePopover: aPopoverPresenter [
	| nearWindow |
	
	"first appearemnce at left, stacking popovers at right"
	nearWindow := aPopoverPresenter owner ifNotNil: #nearWindowLike.
	(nearWindow isNotNil and: [ nearWindow isPopover ])
		ifTrue: [ aPopoverPresenter bePositionRight ]
		ifFalse: [ aPopoverPresenter bePositionBottom ].
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action
		shortcutKey: KeyboardKey down mod3;
		action: [
			self withPopoverDo: #dismiss.
			self notifyActivateEntity: self model ] ]
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> initializePresenters [

	self
		addStyle: 'pulsarFlyingBrowser';
		addStyle: 'pulsarInspectorFlyingBrowser';
		addStyle: 'pulsarMillerColumnInspector'.

	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.

	millerList := SpBoxLayout newHorizontal beHomogeneous.
	panelsList := SpBoxLayout newHorizontal.
	
	rangeLabelPresenter := self newLabel 
		label: self rangeString;
		yourself.
	
	incColumnsButtonPresenter := self newButton
		addStyle: 'flat';
		icon: (self iconNamed: 'plus');
		action: [ self visiblePanels: self visiblePanels + 1 ];
		yourself.
	
	visibleColumnsPresenter := self newLabel
		label: self visiblePanels + 1;
		yourself.

	decColumnsButtonPresenter := self newButton
		addStyle: 'flat';
		icon: (self iconNamed: 'minus');
		action: [ self visiblePanels: self visiblePanels - 1 ];
		yourself.

	
	paginatorPresenter := self addPaginator.
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: (self model ifNotNil: [ :aModel | aModel fullName ] ifNil: [ '' ]);
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'accessing' }
PulsarMillerColumnInspector >> insertPopover: aPresenter [

	millerList children last ifNotNil: [ :presenter | presenter insertPopover: aPresenter ]
]

{ #category : 'testing' }
PulsarMillerColumnInspector >> isVisible: aPresenter [

	^ self visibleRange includes: (self indexOfPage: aPresenter)
]

{ #category : 'private' }
PulsarMillerColumnInspector >> lastPageName [

	^ millerList children
		ifNotEmpty: [ :children | children last selectedPageName ]
		ifEmpty: [ nil ]
]

{ #category : 'private' }
PulsarMillerColumnInspector >> moveTo: aNumber [

	self moveTo: aNumber force: false
]

{ #category : 'private' }
PulsarMillerColumnInspector >> moveTo: aNumber force: forceBoolean [

	"if is already visible, skip"
	(forceBoolean not and: [ self visibleRange includes: aNumber]) 
		ifTrue: [ ^ self ].
	
	visibleRange := aNumber < self visibleRange first 
		ifTrue: [ aNumber to: (aNumber + self visiblePanels - 1) ]
		ifFalse: [ (aNumber - self visiblePanels + 1) to: aNumber ].
	
	self updateVisibleColumns
]

{ #category : 'private - notifying' }
PulsarMillerColumnInspector >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private' }
PulsarMillerColumnInspector >> pageRemoved: aPresenter [

	self application defer: [
		| indexOfNextPage |
		indexOfNextPage := (self indexOfPage: aPresenter) - 1.
		self removePanelsFrom: (millerList children at: indexOfNextPage).
		self 
			moveTo: indexOfNextPage
			force: true ]
]

{ #category : 'private' }
PulsarMillerColumnInspector >> rangeString [
	
	^ self visibleRange asString
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> registerToEvents [

	self announcer
		when: PulsarThemeChanged send: #eventThemeChanged: to: self;
		when: PulsarSyntaxHighlightThemeChanged send: #eventSyntaxHighlightThemeChanged: to: self
]

{ #category : 'private' }
PulsarMillerColumnInspector >> removePanelsFrom: presenter [
	| index |

	index := self indexOfPage: presenter.
	millerList children copy reverseDo: [ :each |
		(self indexOfPage: each) > index 
			ifTrue: [ millerList remove: each ] ]
]

{ #category : 'private' }
PulsarMillerColumnInspector >> resetVisibleRange [

	visibleRange := nil
]

{ #category : 'private' }
PulsarMillerColumnInspector >> setIndexOfPage: aPresenter to: aNumber [

	aPresenter 
		propertyAt: #index
		put: aNumber
]

{ #category : 'private' }
PulsarMillerColumnInspector >> shiftRange: aNumber [

	(aNumber < 0 and: [ self visibleRange first = 1 ]) ifTrue: [ ^ self ].
	(aNumber > 0 and: [ self visibleRange last = millerList children size ]) ifTrue: [ ^ self ].
	
	visibleRange := visibleRange + aNumber.
	
	self updateVisibleColumns
]

{ #category : 'private - updating' }
PulsarMillerColumnInspector >> updatePaginator [

	millerList children size = 1 ifTrue: [
		paginatorPresenter hide.
		^ self ].

	paginatorPresenter show.
	panelsList removeAll.
	millerList children withIndexDo: [ :each :index |
		panelsList add: ((self isVisible: each)
			ifTrue: [ 
				self newImage
					addStyle: 'paginatorPanelMarker';
					image: (self iconNamed: 'inspector-column-shown');
					help: each model windowTitle;
					yourself]
			ifFalse: [ 
				self newButton
					addStyle: 'paginatorPanelMarker';
					addStyle: 'flat';
					action: [ self moveTo: index ];
					icon: (self iconNamed: 'inspector-column-hidden');
					help: each model windowTitle;
					yourself ]) 
	]
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> updatePresenter [

	self model ifNil: [ ^ self ].

	self updateTitle.
	self addColumn: self model
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> updateTitle [

	headerPresenter title: 'Inspector'
]

{ #category : 'private - updating' }
PulsarMillerColumnInspector >> updateVisibleColumns [
	| size |

	self application defer: [
		visibleColumnsPresenter label: self visiblePanels asString.
		rangeLabelPresenter label: self rangeString.
		
		size := millerList children size.
		millerList children withIndexDo: [ :each :index |
			each visible: (self isVisible: each) ].
		self updatePaginator ]
]

{ #category : 'accessing' }
PulsarMillerColumnInspector >> visiblePanels [

	^ visiblePanels ifNil: [ self class defaultVisiblePanels ]
]

{ #category : 'accessing' }
PulsarMillerColumnInspector >> visiblePanels: aNumber [

	visiblePanels := aNumber max: 1.
	self updatePresenter
]

{ #category : 'accessing' }
PulsarMillerColumnInspector >> visibleRange [

	^ visibleRange ifNil: [ 
		visibleRange := (((millerList children size - self visiblePanels) + 1) max: 1) to: (millerList children size max: 1) ]
]
