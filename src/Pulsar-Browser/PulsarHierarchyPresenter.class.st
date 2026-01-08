Class {
	#name : 'PulsarHierarchyPresenter',
	#superclass : 'PvMethodHierarchyPresenter',
	#traits : 'PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot',
	#classTraits : 'PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait',
	#instVars : [
		'headerPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
PulsarHierarchyPresenter >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: PulsarPopoverControlBoxPresenter.
	controlsPresenter onPulsar: [ 
		self withPopoverDo: #dismiss.
		self notifyActivateEntity: self model ].
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'initialization' }
PulsarHierarchyPresenter >> connectPresenters [

	super connectPresenters. 
	self transmitDo: [ :aModel | 
		self notifyActivateEntity: aModel.
		self withPopoverDo: #dismiss ]
]

{ #category : 'api - focus' }
PulsarHierarchyPresenter >> defaultKeyboardFocus [

	^ treePresenter
]

{ #category : 'layout' }
PulsarHierarchyPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: headerPresenter expand: false;
		add: treePresenter;
		yourself
]

{ #category : 'initialization' }
PulsarHierarchyPresenter >> headerTitle [

	^ self model fullName
]

{ #category : 'initialization' }
PulsarHierarchyPresenter >> initializePopover: aPopoverPresenter [

	aPopoverPresenter bePositionBottom.
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: KeyboardKey down mod3;
		action: [ 
			self withPopoverDo: #dismiss.
			self notifyActivateEntity: self model ] ]
]

{ #category : 'initialization' }
PulsarHierarchyPresenter >> initializePresenters [

	super initializePresenters.
	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	
	treePresenter searchMatching: [ :anEntity :pattern | 
		self isEntity: anEntity matching: pattern ].
	
	self removeStyle: 'pvNavigation'.
	self removeStyle: 'pvMethodHierarchyNavigation'.
	self addStyle: 'dockFlyingBrowser'.
	self addStyle: 'dockHierarchyFlyingBrowser'.

]

{ #category : 'private - testing' }
PulsarHierarchyPresenter >> isEntity: anEntity matching: pattern [
	
	^ anEntity fullName asLowercase beginsWith: pattern asLowercase
]

{ #category : 'initialization' }
PulsarHierarchyPresenter >> itemToSelect [

	^ self model parentModel
]

{ #category : 'private - announcing' }
PulsarHierarchyPresenter >> notifyActivateEntity: anEntity [
	| announcement |

	anEntity ifNil: [ ^ self ].

	announcement := anEntity realModel newActivationAnnouncement.
	
	"if I am in a panel window, I want to show the activation in the next column. 
	 it it is the first column (at the left, the most usual case), I put it next, 
	 if is in another column, I put it previous"
	self withPanelWindowDo: [ :aPanelWindow |
		"just if I am inside a panel window and I am not e.g. a popover"
		self nearWindowLike = aPanelWindow ifTrue: [
			announcement desiredPosition: (aPanelWindow panelPosition copy
				column: ((aPanelWindow panelPosition column > 1) 
					ifTrue: [ aPanelWindow panelPosition column - 1 ]
					ifFalse: [ aPanelWindow panelPosition column + 1 ]);
				yourself) ] ].
				
	self notificationCenter announce: announcement
]

{ #category : 'private - announcing' }
PulsarHierarchyPresenter >> notifyEntityChanged: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (PulsarModelChanged newValue: anEntity realModel)
]

{ #category : 'private - announcing' }
PulsarHierarchyPresenter >> notifyEntityRemoved: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (PulsarModelRemoved newValue: anEntity realModel)
]

{ #category : 'private - announcing' }
PulsarHierarchyPresenter >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity realModel newSelectionAnnouncement
]

{ #category : 'accessing - snapshot' }
PulsarHierarchyPresenter >> snapshot [

	^ PulsarHierarchySnapshot on: self
]

{ #category : 'accessing' }
PulsarHierarchyPresenter >> spotterTitle [
	
	^ self model name
]

{ #category : 'private' }
PulsarHierarchyPresenter >> treePresenter [

	^ treePresenter
]

{ #category : 'initialization' }
PulsarHierarchyPresenter >> updatePresenter [

	super updatePresenter.
	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self headerTitle ]
]
