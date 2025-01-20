Class {
	#name : 'DockRawInspectionPresenter',
	#superclass : 'StRawInspectionPresenter',
	#instVars : [
		'headerPresenter'
	],
	#category : 'Dock-Browser-Tool-Inspector',
	#package : 'Dock-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'initialization' }
DockRawInspectionPresenter >> addPopoverControls [
	
	headerPresenter addPresenter: (self instantiate: DockPopoverControlBoxPresenter)
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

{ #category : 'initialization' }
DockRawInspectionPresenter >> initializePopover: aPopoverPresenter [

	aPopoverPresenter bePositionBottom.
	self addPopoverControls
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
