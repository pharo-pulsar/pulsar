Class {
	#name : 'DockProtocolButtonPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'protocolPresenter',
		'protocolChangedAction'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'private' }
DockProtocolButtonPresenter >> annnounceProtocolChanged [

	protocolChangedAction ifNil: [ ^ self ].
	protocolChangedAction cull: protocolPresenter label
]

{ #category : 'layout' }
DockProtocolButtonPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: protocolPresenter;
		yourself
]

{ #category : 'initialization' }
DockProtocolButtonPresenter >> initializePresenters [

	protocolPresenter := self newButton
		addStyle: 'flat';
		addStyle: 'pvProtocol';
		icon: (self iconNamed: 'tag');
		action: [ self popupProtocol ];
		yourself
]

{ #category : 'actions' }
DockProtocolButtonPresenter >> popupProtocol [
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
DockProtocolButtonPresenter >> updatePresenter [

	protocolPresenter label: (self model 
		ifNotNil: [ :aModel | aModel protocolName ]
		ifNil: [ '(None)' ])
]

{ #category : 'events' }
DockProtocolButtonPresenter >> whenProtocolChangedDo: aBlock [

	protocolChangedAction := aBlock
]
