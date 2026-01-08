Class {
	#name : 'PulsarMessageBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait',
	#instVars : [
		'messageListPresenter',
		'editorPresenter',
		'headerPresenter',
		'countPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Messages',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Messages'
}

{ #category : 'defaults' }
PulsarMessageBrowser class >> defaultPanelPosition [

	^ SpPanelPosition new 
		area: SpPanelArea center;
		yourself
]

{ #category : 'initialization' }
PulsarMessageBrowser >> acceptMethod: aMehodModel [

	self withPopoverDo: [ :aPopover | aPopover dismiss ].
	self notifyActivateEntity: aMehodModel
]

{ #category : 'initialization' }
PulsarMessageBrowser >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: PulsarPopoverControlBoxPresenter.
	controlsPresenter onPulsar: [ 
		self withPopoverDo: #dismiss.
		self notifyActivateEntity: self model ].
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'initialization' }
PulsarMessageBrowser >> connectPresenters [

	messageListPresenter transmitTo: editorPresenter.
	messageListPresenter outputActivationPort
		transmitDo: [ :aMehodModel | self acceptMethod: aMehodModel ]
]

{ #category : 'api - focus' }
PulsarMessageBrowser >> defaultKeyboardFocus [

	^ messageListPresenter
]

{ #category : 'layout' }
PulsarMessageBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: (SpPanedLayout newVertical
			add: messageListPresenter;
			add: editorPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarMessageBrowser >> initializePopover: aPopoverPresenter [
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
			self withPopoverDo: #dismiss.
			self notifyActivateEntity: self model ] ]
]

{ #category : 'initialization' }
PulsarMessageBrowser >> initializePresenters [

	self addStyle: 'dockFlyingBrowser'.
	self addStyle: 'dockMessageFlyingBrowser'.
	
	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	countPresenter := self newLabel
		addStyle: 'count';
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself.
	headerPresenter addPresenter: countPresenter.

	messageListPresenter := self newFilteringList
		addStyle: 'stList';
		display: #fullName;
		whenFilterChangedDo: [ self updateCount ];
		yourself.
	editorPresenter := self instantiate: PulsarMethodEditor
]

{ #category : 'private' }
PulsarMessageBrowser >> messageCount [
	| shownSize fullSize |

	fullSize := messageListPresenter unfilteredItems size.
	fullSize = 0 ifTrue: [ ^ '' ].
	shownSize := messageListPresenter items size.	
	^ shownSize = fullSize
		ifTrue: [ shownSize asString ]
		ifFalse: [ '{1} / {2}' format: { shownSize. fullSize } ]
]

{ #category : 'private' }
PulsarMessageBrowser >> notificationCenter: anAnnouncer [

	notificationCenter := anAnnouncer.
	editorPresenter notificationCenter: anAnnouncer
]

{ #category : 'private - announcing' }
PulsarMessageBrowser >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity realModel newActivationAnnouncement
]

{ #category : 'accessing' }
PulsarMessageBrowser >> panelPosition [

	^ panelPosition ifNil: [ panelPosition := self class defaultPanelPosition ]
]

{ #category : 'accessing - snapshot' }
PulsarMessageBrowser >> snapshot [

	^ PulsarMessageSnapshot on: self
]

{ #category : 'initialization' }
PulsarMessageBrowser >> updateCount [

	countPresenter label: self messageCount
]

{ #category : 'initialization' }
PulsarMessageBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [ 
		headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
			aBreadcrumb addSegment: self model title ].
		messageListPresenter items: self model methodModels.
		self updateCount ]
]
