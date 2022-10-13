Class {
	#name : #PvMethodEditorFooterPresenter,
	#superclass : #PvEditorFooterPresenter,
	#instVars : [
		'protocolButtonPresenter'
	],
	#category : #'Perspective-Method-View'
}

{ #category : #layout }
PvMethodEditorFooterPresenter >> defaultLayout [

	^ super defaultLayout
		add: protocolButtonPresenter expand: false;
		yourself
]

{ #category : #initialization }
PvMethodEditorFooterPresenter >> initializePresenters [

	super initializePresenters.
	protocolButtonPresenter := self newButton
		addStyle: 'flat';
		addStyle: 'pvProtocol';
		icon: (self application iconNamed: 'tag');
		action: [ self popupProtocol ];
		yourself
]

{ #category : #'as yet unclassified' }
PvMethodEditorFooterPresenter >> popupProtocol [
	| chooser popover |

	chooser := self instantiate: PvMethodProtocolChooserPresenter on: self model.
	chooser onSelect: [ :aString |
		popover dismiss.
		self announce: (PvMethodEditorProtocolChanged new 
			newProtocol: aString;
			yourself) ].
	(popover := self newPopover) 
		presenter: chooser;
		relativeTo: protocolButtonPresenter;
		bePositionTop;
		popup
]

{ #category : #initialization }
PvMethodEditorFooterPresenter >> updatePresenter [

	super updatePresenter.
	self model ifNil: [ ^ self ].
	protocolButtonPresenter label: self model protocol
]
