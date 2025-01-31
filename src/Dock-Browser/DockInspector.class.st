Class {
	#name : 'DockInspector',
	#superclass : 'SpPresenter',
	#traits : 'DockTNotificationCenter + DockTPanelWindow + DockTSnapshot + SpTModel',
	#classTraits : 'DockTNotificationCenter classTrait + DockTPanelWindow classTrait + DockTSnapshot classTrait + SpTModel classTrait',
	#instVars : [
		'headerPresenter',
		'inspectionsPresenter'
	],
	#category : 'Dock-Browser-Tool-Inspector',
	#package : 'Dock-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'initialization' }
DockInspector >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: DockPopoverControlBoxPresenter.
	controlsPresenter onDock: [ 
		self notifyActivateEntity: self model.
		self withPopoverDo: #dismiss ].
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'private' }
DockInspector >> allContexts [

	^ self model objectInspectionContexts
]

{ #category : 'private' }
DockInspector >> allPages [
	
	^ self allContexts 
		collect: [ :each | self newPageForContext: each ]
]

{ #category : 'api - focus' }
DockInspector >> defaultKeyboardFocus [

	^ inspectionsPresenter
]

{ #category : 'layout' }
DockInspector >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: inspectionsPresenter;
		yourself
]

{ #category : 'initialization' }
DockInspector >> initializePopover: aPopoverPresenter [

	aPopoverPresenter bePositionBottom.
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: KeyboardKey down mod3;
		action: [ self notifyActivateEntity: self model ] ]	
]

{ #category : 'initialization' }
DockInspector >> initializePresenters [

	self
		addStyle: 'dockFlyingBrowser';
		addStyle: 'dockInspectorFlyingBrowser'.
		
	headerPresenter := self instantiate: DockEditorToolbarPresenter.
	inspectionsPresenter := self newNotebook
]

{ #category : 'initialization' }
DockInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model fullName;
		whenClosedDo: [ self notifyEditorClosed  ]
]

{ #category : 'private' }
DockInspector >> inspectedObject [
 	
	^ self model inspectedObject
]

{ #category : 'private' }
DockInspector >> newInspectionForContext: aContext [

	^ self 
		instantiate: StObjectContextPresenter 
		on: (StObjectContextModel new 
			inspection: self model;
			inspectedObject: self inspectedObject;
			context: aContext; 
			yourself)
]

{ #category : 'private' }
DockInspector >> newPageForContext: aContext [

	^ SpNotebookPage new
		title: aContext title;
		presenterProvider: [ self newInspectionForContext: aContext ];
		"whenRetrievedDo: [ :presenter | 
			self keepPresenter: presenter.
			self addActivationTo: presenter ];"
		yourself
]

{ #category : 'initialization' }
DockInspector >> updatePages [

	inspectionsPresenter
		pages: self allPages;
		selectPageIndex: 1
]

{ #category : 'initialization' }
DockInspector >> updatePresenter [

	self model ifNil: [ ^ self ].

	self updateTitle.
	self updatePages
]

{ #category : 'initialization' }
DockInspector >> updateTitle [
	
	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self model windowTitle ]
]
