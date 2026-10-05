"
A single-object inspector, to be shown as a popover or docked in a browser, displaying the inspections of one object as pages of a notebook in `PulsarMillerColumnInspector`.

It has one page per object inspection context (see `allContexts`), each page hosting a object context presenter created lazily by `newInspectionForContext:`. It also implements the `SpTActivable` protocol: clients register a block with `whenActivatedDo:` that is evaluated by `activateWith:` when the inspector is activated.
"
Class {
	#name : 'PulsarSingleInspector',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTEditor + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot + PulsarTPopover + SpTActivable',
	#classTraits : 'SpTModel classTrait + PulsarTEditor classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait + PulsarTPopover classTrait + SpTActivable classTrait',
	#instVars : [
		'headerPresenter',
		'inspectionsPresenter',
		'closeAction',
		'closeButtonPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'private - actions' }
PulsarSingleInspector >> activateWith: aNode [
	"override to react to an activation detail"
	
	activationAction ifNil: [ ^ self ].
	activationAction cull: (SpActivatedSelection newValue: aNode)
]

{ #category : 'private' }
PulsarSingleInspector >> addActivationTo: aPresenter [
	
	aPresenter hasOutputActivationPort ifFalse: [ ^ self ]. 
	self isActiveOnSingleClick ifTrue: [ aPresenter activateOnSingleClick ].
	aPresenter outputActivationPort 
		transmitDo: [ :selection | self activateWith: selection ]
]

{ #category : 'initialization' }
PulsarSingleInspector >> addPopoverControls [

	headerPresenter addPresenter: self newPopoverControlBoxPresenter
]

{ #category : 'private' }
PulsarSingleInspector >> allContexts [

	^ self model objectInspectionContexts
]

{ #category : 'private' }
PulsarSingleInspector >> allPages [
	
	^ self allContexts 
		collect: [ :each | self newPageForContext: each ]
]

{ #category : 'private - announcing' }
PulsarSingleInspector >> announceClose [

	closeAction ifNil: [ ^ self ].
	closeAction cull: self
]

{ #category : 'api - focus' }
PulsarSingleInspector >> defaultKeyboardFocus [

	^ inspectionsPresenter
]

{ #category : 'layout' }
PulsarSingleInspector >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: inspectionsPresenter;
		yourself
]

{ #category : 'events' }
PulsarSingleInspector >> eventSyntaxHighlightThemeChanged: ann [

	self traversePresentersDo: [ :each | each pulsarSyntaxHighlightThemeChanged ]
]

{ #category : 'events' }
PulsarSingleInspector >> eventThemeChanged: ann [

	self traversePresentersDo: [ :each | each pulsarThemeChanged ]
]

{ #category : 'initialization' }
PulsarSingleInspector >> initialize [

	super initialize.
	self registerToEvents
]

{ #category : 'initialization' }
PulsarSingleInspector >> initializePopover: aPopoverPresenter [
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
PulsarSingleInspector >> initializePresenters [
		
	self addStyle: 'pulsarSingleInspector'.
		
	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	headerPresenter addPresenter: (self newToolbar 
		beIcons;
		add: ((closeButtonPresenter := self newButton)
			addStyle: 'flat';
			icon: (self iconNamed: 'close-panel');
			help: 'Close inspector page';
			action: [ self announceClose ];
			yourself);
		yourself).
	closeButtonPresenter hide.
	
	inspectionsPresenter := self newNotebook
]

{ #category : 'initialization' }
PulsarSingleInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model ifNotNil: [ :aModel | aModel fullName ] ifNil: [ '' ]);
		whenClosedDo: [ self notifyEditorClosed  ]
]

{ #category : 'accessing' }
PulsarSingleInspector >> insertPopover: aPresenter [

	inspectionsPresenter selectedPage activePresenter insertPopover: aPresenter
]

{ #category : 'private' }
PulsarSingleInspector >> inspectedObject [
 	
	^ self model inspectedObject
]

{ #category : 'testing' }
PulsarSingleInspector >> isActiveOnSingleClick [

	^ true
]

{ #category : 'accessing' }
PulsarSingleInspector >> maybeSelectPageNamed: aName [

	inspectionsPresenter pages 
		detect: [ :each | each title = aName ]
		ifFound: [ :aPage | inspectionsPresenter selectPage: aPage ]
]

{ #category : 'private' }
PulsarSingleInspector >> newInspectionForContext: aContext [

	^ self 
		instantiate: StObjectContextPresenter 
		on: (StObjectContextModel new 
			inspection: self model;
			inspectedObject: self inspectedObject;
			context: aContext; 
			yourself)
]

{ #category : 'private' }
PulsarSingleInspector >> newPageForContext: aContext [

	^ SpNotebookPage new
		title: aContext title;
		presenterProvider: [ self newInspectionForContext: aContext ];
		whenRetrievedDo: [ :presenter | 
			"self keepPresenter: presenter."
			self addActivationTo: presenter ];
		yourself
]

{ #category : 'private - announcing' }
PulsarSingleInspector >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private' }
PulsarSingleInspector >> panelPlacedIconName [

	^ 'inspector'
]

{ #category : 'initialization' }
PulsarSingleInspector >> registerToEvents [

	self announcer 
		when: PulsarThemeChanged send: #eventThemeChanged: to: self;
		when: PulsarSyntaxHighlightThemeChanged send: #eventSyntaxHighlightThemeChanged: to: self
]

{ #category : 'accessing' }
PulsarSingleInspector >> selectPageName: aName [

	inspectionsPresenter pages 
		detect: [ :each | each title = aName ]
		ifFound: [ :aPage | inspectionsPresenter selectPage: aPage ]
]

{ #category : 'accessing' }
PulsarSingleInspector >> selectedPageName [

	^ inspectionsPresenter selectedPage ifNotNil: #title
]

{ #category : 'accessing - snapshot' }
PulsarSingleInspector >> snapshot [

	^ PulsarInspectorSnapshot on: self
]

{ #category : 'initialization' }
PulsarSingleInspector >> updatePages [

	inspectionsPresenter
		pages: self allPages;
		selectPageIndex: 1
]

{ #category : 'initialization' }
PulsarSingleInspector >> updatePresenter [

	self model ifNil: [ ^ self ].

	self updateTitle.
	self updatePages
]

{ #category : 'initialization' }
PulsarSingleInspector >> updateTitle [
	
	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self model name ]
]

{ #category : 'api - events' }
PulsarSingleInspector >> whenClosedDo: aBlock [

	closeAction := aBlock.
	closeButtonPresenter show
]
