Class {
	#name : 'DockMessageBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTNotificationCenter',
	#classTraits : 'SpTModel classTrait + DockTNotificationCenter classTrait',
	#instVars : [
		'messageListPresenter',
		'editorPresenter',
		'headerPresenter'
	],
	#category : 'Dock-Browser-Tool-Messages',
	#package : 'Dock-Browser',
	#tag : 'Tool-Messages'
}

{ #category : 'initialization' }
DockMessageBrowser >> acceptMethod: aMehodModel [

	self withPopoverDo: [ :aPopover | aPopover dismiss ].
	self notifyActivateEntity: aMehodModel
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

{ #category : 'initialization' }
DockMessageBrowser >> initializePopover: aPopoverPresenter [

	aPopoverPresenter bePositionBottom
]

{ #category : 'initialization' }
DockMessageBrowser >> initializePresenters [

	self addStyle: 'dockFlyingBrowser'.
	self addStyle: 'dockMessageFlyingBrowser'.
	headerPresenter := self instantiate: DockEditorToolbarPresenter.

	messageListPresenter := self newEasyListView
		display: #fullName;
		yourself.
	editorPresenter := self instantiate: DockMethodEditor
]

{ #category : 'private' }
DockMessageBrowser >> notificationCenter: anAnnouncer [

	notificationCenter := anAnnouncer.
	editorPresenter notificationCenter: anAnnouncer
]

{ #category : 'initialization' }
DockMessageBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self model title ].
	messageListPresenter items: self model methodModels
]
