Class {
	#name : 'DockVersionsBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTNotificationCenter + DockTPanelWindow + DockTSnapshot',
	#classTraits : 'SpTModel classTrait + DockTNotificationCenter classTrait + DockTPanelWindow classTrait + DockTSnapshot classTrait',
	#instVars : [
		'headerPresenter',
		'versionListPresenter',
		'patchPresenter',
		'sourcePresenter'
	],
	#category : 'Dock-Browser-Tool-Versions',
	#package : 'Dock-Browser',
	#tag : 'Tool-Versions'
}

{ #category : 'initialization' }
DockVersionsBrowser >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: DockPopoverControlBoxPresenter.
	controlsPresenter onDock: [ 
		self notifyActivateEntity: self model.
		self withPopoverDo: #dismiss ].
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'initialization' }
DockVersionsBrowser >> connectPresenters [
	
	versionListPresenter transmitDo: [ :aDefinition | 
		self updateSourceWith: aDefinition ]
]

{ #category : 'api - focus' }
DockVersionsBrowser >> defaultKeyboardFocus [

	^ versionListPresenter
]

{ #category : 'layout' }
DockVersionsBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: (SpPanedLayout newHorizontal
			positionOfSlider: 200;
			add: versionListPresenter;
			add: (SpTabLayout new 
				add: patchPresenter label: 'Patch';
				add: sourcePresenter label: 'Source';
				yourself);
			yourself);
		yourself
]

{ #category : 'initialization' }
DockVersionsBrowser >> initializePopover: aPopoverPresenter [
	
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: Character arrowDown mod3;
		action: [ 
			self notifyActivateEntity: self model.
			self withPopoverDo: #dismiss ] ]
]

{ #category : 'initialization' }
DockVersionsBrowser >> initializePresenters [

	self addStyle: 'dockFlyingBrowser'.
	self addStyle: 'dockVersionsFlyingBrowser'.
	
	headerPresenter := self instantiate: DockEditorToolbarPresenter.
	versionListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :aDefinition | aDefinition timeStamp epiceaBrowsersAsString ];
		yourself.
	patchPresenter := self instantiate: SpPatchPresenter.
	patchPresenter addStyle: 'stCode'.
	
	sourcePresenter := self newCode
		editable: false;
		yourself
]

{ #category : 'initialization' }
DockVersionsBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model fullName;
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'initialization' }
DockVersionsBrowser >> updatePatchWith: aDefinition [
	| nextDefinition |
	nextDefinition := versionListPresenter items 
		after: aDefinition 
		ifAbsent: [ nil ].
		
	patchPresenter
		patchFrom: (nextDefinition 
			ifNotNil: [ nextDefinition sourceCode ]
			ifNil: [ '' ])
		to: aDefinition sourceCode
]

{ #category : 'initialization' }
DockVersionsBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [ 
		headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
			aBreadcrumb addSegment: self model title ].	
		versionListPresenter 
			items: self model versions; 
			selectFirst ]
]

{ #category : 'initialization' }
DockVersionsBrowser >> updateSourceCodeWith: aDefinition [
		
	sourcePresenter 
		beForMethod: aDefinition method;
		text: aDefinition sourceCode
]

{ #category : 'initialization' }
DockVersionsBrowser >> updateSourceWith: aDefinition [
	
	aDefinition ifNil: [ ^ self ].
	
	self updatePatchWith: aDefinition.
	self updateSourceCodeWith: aDefinition
]
