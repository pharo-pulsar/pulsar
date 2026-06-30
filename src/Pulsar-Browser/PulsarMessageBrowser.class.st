"
A message browser (to show senders and implementors)
"
Class {
	#name : 'PulsarMessageBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTEditor + PulsarTSnapshot + PulsarTPopover',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTEditor classTrait + PulsarTSnapshot classTrait + PulsarTPopover classTrait',
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

	^ SpPanelPosition centerArea
]

{ #category : 'initialization' }
PulsarMessageBrowser >> acceptMethod: aMehodModel [

	self withPopoverDo: [ :aPopover | aPopover dismiss ].
	self notifyActivateEntity: aMehodModel
]

{ #category : 'initialization' }
PulsarMessageBrowser >> addPopoverControls [

	headerPresenter addPresenter: self newPopoverControlBoxPresenter
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

	self addStyle: 'pulsarFlyingBrowser'.
	self addStyle: 'pulsarMessageFlyingBrowser'.
	
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
		
	editorPresenter := self instantiate: PulsarMethodEditor.
	editorPresenter shouldUpdateTitle: false
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

	self basicNotificationCenter: anAnnouncer.
	"as notificationCenter may be other thing than anAnnouncer"
	editorPresenter notificationCenter: self notificationCenter
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
