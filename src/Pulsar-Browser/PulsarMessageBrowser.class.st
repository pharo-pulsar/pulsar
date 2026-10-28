"
A message-set browser for Pulsar. It presents the result of a system query — senders, implementors, references, stores, and similar method sets — as a filterable list paired with a method preview, so those results can be explored and opened without leaving the current browsing context.

The browser is driven by `PulsarMessageModel`, which supplies the query title, the environment, and the compiled methods; each method is presented through a lazy `PvMethodModel`. The model is a fixed result rather than a live query: filtering only narrows the displayed entries, it never reruns the query. The header shows the title as a breadcrumb and reports the visible and total message counts.

Selecting an entry transmits its method model to the embedded `PulsarMethodEditor`, where the method can be read and edited. Activating an entry announces it through the Pulsar notification center and, for a popover, closes the popover so navigation continues in the target editor. System navigation normally opens the browser through `PulsarSystemNavigation>>browseMessageList:name:autoSelect:refreshingBlock:` as a popover attached to the responder; it can also be pinned or docked in an editor panel or detached into a `PulsarDetachedBrowser`. It participates in Pulsar's editor and panel protocols but is not itself an editable document.

A `PulsarMessageSnapshot` records when the browser was last presented, so a restored session can preserve its recency.

Example:
```smalltalk
PulsarMessageBrowser
    newApplication: anApplication
    model: (PulsarMessageModel
        newEnvironment: (PvEnvironmentModel onSystem)
        title: 'Senders of #printString'
        methods: (SystemNavigation default allCallsOn: #printString))
    open
```

See `PulsarMessageModel` for the query-result model and `PulsarMessageBrowserTest` for a minimal construction with a fixed method set.
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

{ #category : 'private - definitions' }
PulsarMessageBrowser >> defineContextActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #methodContext with: [ :group | group 
		addActionWith: [ :action | action 
			dynamicName: [ f'Inspect [self selectedItemName]' ];
			description: 'Inspect current method';
			shortcutKey: $i actionModifier;
			actionEnabled: [ self selectedItem isNotNil ];
			action: [ self systemNavigation inspect: self selectedItem entity ] ] ]
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
		actions: (SpActionGroup new 
			add: self actions;
			addDynamicGroupWith: [ :group | 
				self selectedItem ifNotNil: [ :aModel | 
					group add: (aModel actionsWithContextOn: self) ] ]);
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
PulsarMessageBrowser >> messageListPresenter [

	^ messageListPresenter
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

{ #category : 'private' }
PulsarMessageBrowser >> selectedItem [

	messageListPresenter ifNil: [ ^ nil ].

	^ messageListPresenter selectedItem
]

{ #category : 'private' }
PulsarMessageBrowser >> selectedItemName [

	^ self selectedItem 
		ifNotNil: [ :aModel | aModel fullName ]
		ifNil: [ 'NONE' ]
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
