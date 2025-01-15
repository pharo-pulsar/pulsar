Class {
	#name : 'DockMessageBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + DockTNotificationCenter',
	#classTraits : 'SpTModel classTrait + DockTNotificationCenter classTrait',
	#instVars : [
		'messageListPresenter',
		'editorPresenter'
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

{ #category : 'layout' }
DockMessageBrowser >> defaultLayout [

	^ SpPanedLayout newVertical
		add: messageListPresenter;
		add: editorPresenter;
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

	messageListPresenter := self newEasyListView
		display: #fullName;
		yourself.
	editorPresenter := self instantiate: DockMethodEditor
]

{ #category : 'initialization' }
DockMessageBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	messageListPresenter items: self model methodModels
]
