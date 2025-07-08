Class {
	#name : 'DockHierarchyPresenter',
	#superclass : 'PvMethodHierarchyPresenter',
	#traits : 'DockTNotificationCenter + DockTPanelWindow + DockTSnapshot',
	#classTraits : 'DockTNotificationCenter classTrait + DockTPanelWindow classTrait + DockTSnapshot classTrait',
	#instVars : [
		'headerPresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
DockHierarchyPresenter >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: DockPopoverControlBoxPresenter.
	controlsPresenter onDock: [ 
		self withPopoverDo: #dismiss.
		self notifyActivateEntity: self model ].
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'initialization' }
DockHierarchyPresenter >> connectPresenters [

	super connectPresenters. 
	self transmitDo: [ :aModel | 
		self notifyActivateEntity: aModel.
		self withPopoverDo: #dismiss ]
]

{ #category : 'api - focus' }
DockHierarchyPresenter >> defaultKeyboardFocus [

	^ treePresenter
]

{ #category : 'layout' }
DockHierarchyPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: headerPresenter expand: false;
		add: treePresenter;
		yourself
]

{ #category : 'initialization' }
DockHierarchyPresenter >> headerTitle [

	^ self model fullName
]

{ #category : 'initialization' }
DockHierarchyPresenter >> initializePopover: aPopoverPresenter [

	aPopoverPresenter bePositionBottom.
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: KeyboardKey down mod3;
		action: [ 
			self withPopoverDo: #dismiss.
			self notifyActivateEntity: self model ] ]
]

{ #category : 'initialization' }
DockHierarchyPresenter >> initializePresenters [

	super initializePresenters.
	headerPresenter := self instantiate: DockEditorToolbarPresenter.
	
	treePresenter searchMatching: [ :anEntity :pattern | 
		self isEntity: anEntity matching: pattern ].
	
	self removeStyle: 'pvNavigation'.
	self removeStyle: 'pvMethodHierarchyNavigation'.
	self addStyle: 'dockFlyingBrowser'.
	self addStyle: 'dockHierarchyFlyingBrowser'.

]

{ #category : 'private - testing' }
DockHierarchyPresenter >> isEntity: anEntity matching: pattern [
	
	^ anEntity fullName asLowercase beginsWith: pattern asLowercase
]

{ #category : 'initialization' }
DockHierarchyPresenter >> itemToSelect [

	^ self model parentModel
]

{ #category : 'accessing - snapshot' }
DockHierarchyPresenter >> snapshot [

	^ DockHierarchySnapshot on: self
]

{ #category : 'accessing' }
DockHierarchyPresenter >> spotterTitle [
	
	^ self model name
]

{ #category : 'private' }
DockHierarchyPresenter >> treePresenter [

	^ treePresenter
]

{ #category : 'initialization' }
DockHierarchyPresenter >> updatePresenter [

	super updatePresenter.
	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self headerTitle ]
]
