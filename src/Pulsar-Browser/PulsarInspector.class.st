"
An inspector to be shown as a popover or docked in a browser.
"
Class {
	#name : 'PulsarInspector',
	#superclass : 'SpPresenter',
	#traits : 'PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot + SpTModel',
	#classTraits : 'PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait + SpTModel classTrait',
	#instVars : [
		'headerPresenter',
		'inspectionsPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'initialization' }
PulsarInspector >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: PulsarPopoverControlBoxPresenter.
	controlsPresenter onPulsar: [ 
		self withPopoverDo: #dismiss.
		self notifyActivateEntity: self model ].
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'private' }
PulsarInspector >> allContexts [

	^ self model objectInspectionContexts
]

{ #category : 'private' }
PulsarInspector >> allPages [
	
	^ self allContexts 
		collect: [ :each | self newPageForContext: each ]
]

{ #category : 'api - focus' }
PulsarInspector >> defaultKeyboardFocus [

	^ inspectionsPresenter
]

{ #category : 'layout' }
PulsarInspector >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: inspectionsPresenter;
		yourself
]

{ #category : 'events' }
PulsarInspector >> eventSyntaxHighlightThemeChanged: ann [

	self allPresenters
		select: [ :each | each isKindOf: SpCodePresenter ]
		thenDo: [ :each | each syntaxHighlightTheme: self application syntaxHighlightTheme ]
]

{ #category : 'events' }
PulsarInspector >> eventThemeChanged: ann [

	self allPresenters
		select: [ :each | each isKindOf: SpCodePresenter ]
		thenDo: [ :each | each styleScheme: self application styleScheme ]
]

{ #category : 'initialization' }
PulsarInspector >> initialize [

	super initialize.
	self registerToEvents
]

{ #category : 'initialization' }
PulsarInspector >> initializePopover: aPopoverPresenter [
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
PulsarInspector >> initializePresenters [

	self
		addStyle: 'dockFlyingBrowser';
		addStyle: 'dockInspectorFlyingBrowser'.
		
	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	inspectionsPresenter := self newNotebook
]

{ #category : 'initialization' }
PulsarInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model ifNotNil: [ :aModel | aModel fullName ] ifNil: [ '' ]);
		windowIcon: (self iconNamed: self panelPlacedIconName);
		whenClosedDo: [ self notifyEditorClosed  ]
]

{ #category : 'accessing' }
PulsarInspector >> insertPopover: aPresenter [

	inspectionsPresenter selectedPage activePresenter insertPopover: aPresenter
]

{ #category : 'private' }
PulsarInspector >> inspectedObject [
 	
	^ self model inspectedObject
]

{ #category : 'private' }
PulsarInspector >> newInspectionForContext: aContext [

	^ self 
		instantiate: StObjectContextPresenter 
		on: (StObjectContextModel new 
			inspection: self model;
			inspectedObject: self inspectedObject;
			context: aContext; 
			yourself)
]

{ #category : 'private' }
PulsarInspector >> newPageForContext: aContext [

	^ SpNotebookPage new
		title: aContext title;
		presenterProvider: [ self newInspectionForContext: aContext ];
		"whenRetrievedDo: [ :presenter | 
			self keepPresenter: presenter.
			self addActivationTo: presenter ];"
		yourself
]

{ #category : 'nil' }
PulsarInspector >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private' }
PulsarInspector >> panelPlacedIconName [

	^ 'inspector'
]

{ #category : 'initialization' }
PulsarInspector >> registerToEvents [

	self announcer 
		when: PulsarThemeChanged send: #eventThemeChanged: to: self;
		when: PulsarSyntaxHighlightThemeChanged send: #eventSyntaxHighlightThemeChanged: to: self
]

{ #category : 'initialization' }
PulsarInspector >> updatePages [

	inspectionsPresenter
		pages: self allPages;
		selectPageIndex: 1
]

{ #category : 'initialization' }
PulsarInspector >> updatePresenter [

	self model ifNil: [ ^ self ].

	self updateTitle.
	self updatePages
]

{ #category : 'initialization' }
PulsarInspector >> updateTitle [
	
	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self model windowTitle ]
]
