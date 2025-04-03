Class {
	#name : 'DockMessageBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTNotificationCenter + DockTPanelWindow + DockTSnapshot',
	#classTraits : 'SpTModel classTrait + DockTNotificationCenter classTrait + DockTPanelWindow classTrait + DockTSnapshot classTrait',
	#instVars : [
		'messageListPresenter',
		'editorPresenter',
		'headerPresenter',
		'countPresenter'
	],
	#category : 'Dock-Browser-Tool-Messages',
	#package : 'Dock-Browser',
	#tag : 'Tool-Messages'
}

{ #category : 'defaults' }
DockMessageBrowser class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea center;
		yourself
]

{ #category : 'initialization' }
DockMessageBrowser >> acceptMethod: aMehodModel [

	self withPopoverDo: [ :aPopover | aPopover dismiss ].
	self notifyActivateEntity: aMehodModel
]

{ #category : 'initialization' }
DockMessageBrowser >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: DockPopoverControlBoxPresenter.
	controlsPresenter onDock: [ 
		self notifyActivateEntity: self model.
		self withPopoverDo: #dismiss ].
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'initialization' }
DockMessageBrowser >> connectPresenters [

	messageListPresenter transmitTo: editorPresenter.
	messageListPresenter outputActivationPort
		transmitDo: [ :aMehodModel | self acceptMethod: aMehodModel ]
]

{ #category : 'api - focus' }
DockMessageBrowser >> defaultKeyboardFocus [

	^ messageListPresenter
]

{ #category : 'layout' }
DockMessageBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: (SpPanedLayout newVertical
			add: messageListPresenter;
			add: editorPresenter;
			yourself);
		yourself
]

{ #category : 'accessing' }
DockMessageBrowser >> dockPosition [

	^ dockPosition ifNil: [ dockPosition := self class defaultDockPosition ]
]

{ #category : 'initialization' }
DockMessageBrowser >> initializePopover: aPopoverPresenter [
	| nearWindow |
	"first appearemnce at left, stacking popovers at right"
	nearWindow := aPopoverPresenter owner ifNotNil: #nearWindowLike.
	(nearWindow isNotNil and: [ nearWindow isPopover ]) 
		ifTrue: [ aPopoverPresenter bePositionRight ]
		ifFalse: [ aPopoverPresenter bePositionBottom ].
	
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: Character arrowDown mod3;
		action: [ 
			self notifyActivateEntity: self model.
			self withPopoverDo: #dismiss ] ]
]

{ #category : 'initialization' }
DockMessageBrowser >> initializePresenters [

	self addStyle: 'dockFlyingBrowser'.
	self addStyle: 'dockMessageFlyingBrowser'.
	
	headerPresenter := self instantiate: DockEditorToolbarPresenter.
	countPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself.
	headerPresenter addPresenter: countPresenter.

	messageListPresenter := self newEasyListView
		addStyle: 'stList';
		display: #fullName;
		yourself.
	editorPresenter := self instantiate: DockMethodEditor
]

{ #category : 'private' }
DockMessageBrowser >> notificationCenter: anAnnouncer [

	notificationCenter := anAnnouncer.
	editorPresenter notificationCenter: anAnnouncer
]

{ #category : 'accessing - snapshot' }
DockMessageBrowser >> snapshot [

	^ DockMessageSnapshot on: self
]

{ #category : 'initialization' }
DockMessageBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [ 
		headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
			aBreadcrumb addSegment: self model title ].
		countPresenter label: self model methodCount asString.	
		messageListPresenter items: self model methodModels ]
]
