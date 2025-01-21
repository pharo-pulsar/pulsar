Class {
	#name : 'DockRawInspectionPresenter',
	#superclass : 'StRawInspectionPresenter',
	#traits : 'DockTNotificationCenter + DockTPanelWindow',
	#classTraits : 'DockTNotificationCenter classTrait + DockTPanelWindow classTrait',
	#instVars : [
		'headerPresenter'
	],
	#category : 'Dock-Browser-Tool-Inspector',
	#package : 'Dock-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'defaults' }
DockRawInspectionPresenter class >> defaultDockPosition [

	^ DockPanelPosition new 
		area: DockArea center;
		yourself
]

{ #category : 'initialization' }
DockRawInspectionPresenter >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: DockPopoverControlBoxPresenter.
	controlsPresenter onDock: [ 
		self notifyActivateEntity: self model.
		self withPopoverDo: #dismiss ].
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'api - focus' }
DockRawInspectionPresenter >> defaultKeyboardFocus [

	^  attributeTable
]

{ #category : 'layout' }
DockRawInspectionPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: super defaultLayout;
		yourself
]

{ #category : 'accessing' }
DockRawInspectionPresenter >> dockPosition [

	^ dockPosition ifNil: [ dockPosition := self class defaultDockPosition ]
]

{ #category : 'initialization' }
DockRawInspectionPresenter >> initializePopover: aPopoverPresenter [

	aPopoverPresenter bePositionBottom.
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: Character arrowDown ctrl;
		action: [ self notifyActivateEntity: self model ] ]	
]

{ #category : 'initialization' }
DockRawInspectionPresenter >> initializePresenters [

	self
		addStyle: 'dockFlyingBrowser';
		addStyle: 'dockInspectorFlyingBrowser'.
		
	headerPresenter := self instantiate: DockEditorToolbarPresenter.
		
	super initializePresenters
]

{ #category : 'initialization' }
DockRawInspectionPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self model windowTitle ].
		
	super updatePresenter
]
