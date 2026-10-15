"
I am the protocol (tag) widget of the method editor toolbar.

I show the protocol of the currently edited method as a clickable link and let the user reclassify that method through a popover chooser, without leaving the editor. I exist to give the method editor a single, self-contained control for viewing and editing a method's protocol.

I hold a method model that knows the current protocol and accepts reclassification, and I open a protocol chooser presenter in the popover. I notify my owner editor when the protocol changes so it can refresh and keep keyboard focus.
"
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
		"add: chooserPresenter expand: false;"
		add: '[';
		add: protocolPresenter;
		add: ']';
		yourself
]

{ #category : 'initialization' }
PulsarProtocolButtonPresenter >> initializePresenters [

	self addStyle: 'pulsarMethodProtocol'.

	protocolPresenter := self newLink
		action: [ self popupProtocol ];
		yourself.
		
	"chooserPresenter := self newButton
		addStyle: 'flat';
		icon: (self iconNamed: 'tag');
		action: [ self popupProtocol ];
		yourself"
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
