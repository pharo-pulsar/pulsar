Class {
	#name : 'PulsarProtocolButtonPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'protocolPresenter',
		'protocolChangedAction',
		'chooserPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'private' }
PulsarProtocolButtonPresenter >> annnounceProtocolChanged [

	protocolChangedAction ifNil: [ ^ self ].
	protocolChangedAction cull: protocolPresenter label
]

{ #category : 'layout' }
PulsarProtocolButtonPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		vAlignCenter;
		add: protocolPresenter;
		add: chooserPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
PulsarProtocolButtonPresenter >> initializePresenters [
	self addStyle: 'pvMethodProtocol'.

	protocolPresenter := self newLabel
		addStyle: 'flat';
		yourself.
		
	chooserPresenter := self newButton
		addStyle: 'flat';
		icon: (self iconNamed: 'tag');
		action: [ self popupProtocol ];
		yourself
]

{ #category : 'actions' }
PulsarProtocolButtonPresenter >> popupProtocol [
	| chooser popover |

	popover := self newPopover.
	
	chooser := (self 
		instantiate: PvMethodProtocolChooserPresenter on: self model)
		onSelect: [ :aString |
			popover dismiss.
			self model classifyMethodAs: aString.
			self updatePresenter.
			self annnounceProtocolChanged.
			self owner takeKeyboardFocus ];
		onAbort: [ 
			popover dismiss.
			self owner takeKeyboardFocus ];
		yourself.

	popover 
		presenter: chooser;
		relativeTo: protocolPresenter;
		bePositionBottom;
		popupModal
]

{ #category : 'initialization' }
PulsarProtocolButtonPresenter >> updatePresenter [

	protocolPresenter label: (self model 
		ifNotNil: [ :aModel | aModel protocolName ]
		ifNil: [ '(None)' ])
]

{ #category : 'events' }
PulsarProtocolButtonPresenter >> whenProtocolChangedDo: aBlock [

	protocolChangedAction := aBlock
]
