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
		'paginatorPresenter'
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
	self application defer: [
		self addPresenterToList: presenter. 
		self updateVisibleColumns ]
]

{ #category : 'layout' }
PulsarMillerColumnInspector >> addPaginator [

	^ self newPresenter 
		layout: (SpBoxLayout newHorizontal
			spacing: 0;
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
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarMillerColumnInspector >> addPopoverControls [

	headerPresenter addPresenter: self newPopoverControlBoxPresenter
]

{ #category : 'private' }
PulsarMillerColumnInspector >> addPresenterToList: presenter [

	self resetVisibleRange.
	millerList add: presenter.
	presenter propertyAt: #index put: millerList children size.
	presenter outputActivationPort
		transmitDo: [ :anObject | 
			self application defer: [ 
				self removePanelsFrom: presenter.
				self addColumn: anObject asInspectorModel ] ]
]

{ #category : '(All)' }
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
		add: (SpBoxLayout newHorizontal
			vAlignCenter;
			add: SpBoxLayout newHorizontal;
			add: paginatorPresenter expand: false;
			add: SpBoxLayout newHorizontal;
			yourself)
		expand: false;
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
		addStyle: 'pulsarMillerInspector'.

	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.

	millerList := SpBoxLayout newHorizontal beHomogeneous.
	panelsList := SpBoxLayout newHorizontal.
	
	paginatorPresenter := self addPaginator
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

	^ self visibleRange includes: (aPresenter propertyAt: #index)
]

{ #category : 'private' }
PulsarMillerColumnInspector >> moveTo: aNumber [

	"if is already visible, skip"
	(self visibleRange includes: aNumber) ifTrue: [ ^ self ].
	
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

{ #category : 'initialization' }
PulsarMillerColumnInspector >> registerToEvents [

	self announcer
		when: PulsarThemeChanged send: #eventThemeChanged: to: self;
		when: PulsarSyntaxHighlightThemeChanged send: #eventSyntaxHighlightThemeChanged: to: self
]

{ #category : 'private' }
PulsarMillerColumnInspector >> removePanelsFrom: presenter [
	| index |

	index := presenter propertyAt: #index.
	millerList children copy reverseDo: [ :each |
		(each propertyAt: #index) > index 
			ifTrue: [ millerList remove: each ] ]
]

{ #category : 'private' }
PulsarMillerColumnInspector >> resetVisibleRange [

	visibleRange := nil
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
				self newLabel 
					label: '◽';
					yourself]
			ifFalse: [ 
				self newButton
					addStyle: 'paginatorPanelMarker';
					addStyle: 'flat';
					action: [ self moveTo: index ];
					label: '▫';
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

	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | aBreadcrumb addSegment: self model windowTitle ]
]

{ #category : 'private - updating' }
PulsarMillerColumnInspector >> updateVisibleColumns [
	| size |

	self application defer: [ 
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
PulsarMillerColumnInspector >> visibleRange [

	^ visibleRange ifNil: [ 
		visibleRange := (((millerList children size - self visiblePanels) + 1) max: 1) to: (millerList children size max: 1) ]
]
