"
This presenter has a miller list to chain object inspections
"
Class {
	#name : 'PulsarInspectorBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot + PulsarTPopover',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait + PulsarTPopover classTrait',
	#instVars : [
		'model',
		'lastPageSelectedTabName',
		'headerPresenter',
		'millerListPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'adding' }
PulsarInspectorBrowser >> addPopoverControls [

	headerPresenter addPresenter: self newPopoverControlBoxPresenter
]

{ #category : 'api - focus' }
PulsarInspectorBrowser >> defaultKeyboardFocus [

	^ millerListPresenter
]

{ #category : 'layout' }
PulsarInspectorBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: millerListPresenter;
		yourself
]

{ #category : 'events' }
PulsarInspectorBrowser >> eventThemeChanged: ann [

	self updatePresentersAfterThemeChange
]

{ #category : 'initialization' }
PulsarInspectorBrowser >> initialize [

	super initialize.
	self registerToEvents
]

{ #category : 'initialization' }
PulsarInspectorBrowser >> initializePopover: aPopoverPresenter [
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
PulsarInspectorBrowser >> initializePresenters [

	self
		addStyle: 'pulsarFlyingBrowser';
		addStyle: 'pulsarInspectorFlyingBrowser'.
		
	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.

	millerListPresenter := self instantiate: SpMillerPaginatorPresenter.
	millerListPresenter millerListPresenter
		spacing: self spacing;
		presenterBlock: [ :aModel | self newInspectorFor: aModel ];
		whenColumnsWillChangeDo: [ self keepLastPageSelectedTabName ]
]

{ #category : 'initialization' }
PulsarInspectorBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: (self model 
			ifNotNil: [ :aModel | aModel windowTitle ] 
			ifNil: [ 'NONAME' ]);
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'accessing' }
PulsarInspectorBrowser >> insertPopover: aPresenter [

	millerListPresenter selectedPage activePresenter insertPopover: aPresenter
]

{ #category : 'private' }
PulsarInspectorBrowser >> keepLastPageSelectedTabName [

	lastPageSelectedTabName := millerListPresenter pages ifNotEmpty: [ :pages | pages last selectedPageName ] ifEmpty: [ nil ]
]

{ #category : 'private - factory' }
PulsarInspectorBrowser >> newInspectorFor: aModel [
	| newInspector |
	
	newInspector := self 
		instantiate: PulsarInspectorPagePresenter 
		on: aModel asInspectorModel.
		
	millerListPresenter pages ifNotEmpty: [ :pages |
		newInspector
			whenClosedDo: [ millerListPresenter removeAllFrom: newInspector ];
			trySelectAnyPageWithName: {
				lastPageSelectedTabName.
				pages last selectedPageName } ].
	
	^ newInspector
]

{ #category : 'initialization' }
PulsarInspectorBrowser >> registerToEvents [

	self announcer 
		when: PulsarThemeChanged send: #eventThemeChanged: to: self;
		when: PulsarSyntaxHighlightThemeChanged send: #eventSyntaxHighlightThemeChanged: to: self
]

{ #category : 'accessing - snapshot' }
PulsarInspectorBrowser >> snapshot [

	^ PulsarInspectorSnapshot on: self
]

{ #category : 'accessing' }
PulsarInspectorBrowser >> spacing [

	^ 5
]

{ #category : 'initialization' }
PulsarInspectorBrowser >> updateMillerList [

	millerListPresenter millerListPresenter 
		resetTo: 0;
		setRootModel: self model
]

{ #category : 'initialization' }
PulsarInspectorBrowser >> updatePresenter [
			
	self updateTitle.
	self updateMillerList
]

{ #category : 'initialization' }
PulsarInspectorBrowser >> updateTitle [

	headerPresenter title: self model windowTitle
]
