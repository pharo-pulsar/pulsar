"
A searchable chooser for the protocol (method category) a method belongs to, opened as a popup from the Pulsar method editor.

A search field sits above a list of all protocols currently defined in the system. Typing selects the first protocol that starts with the typed text; pressing Enter, or activating a list item, confirms the choice and hands the protocol name to the host through the block installed with `onSelect:`. Escape runs the `onAbort:` block instead, letting the host dismiss the popup without changing anything. Typing a leading `*` swaps the list for the names of extension packages, so a method can also be moved into an extension protocol.

The presenter is instantiated (`instantiate:on:`) on the method editor's method model, which must answer `protocolName` so the chooser opens pre-selected on the method's current protocol. What a selection means is left entirely to the host: reclassifying the method, closing the popover and returning keyboard focus are the host's job. Both current hosts embed this presenter in a popover anchored on the protocol button of the method editor — see `PulsarProtocolButtonPresenter>>#popupProtocol` and `PvMethodEditorFooterPresenter>>#popupProtocol`.

Example:

```smalltalk
chooser := self instantiate: PvMethodProtocolChooserPresenter on: methodModel.
chooser
	onSelect: [ :protocolName | self model classifyMethodAs: protocolName ];
	onAbort: [ popover dismiss ].
popover
	presenter: chooser;
	relativeTo: protocolButton;
	popup.
```
"
Class {
	#name : 'PvMethodProtocolChooserPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'protocolNamePresenter',
		'protocolListPresenter',
		'selectAction',
		'abortAction',
		'protocols',
		'updating',
		'protocolListKind',
		'extensions'
	],
	#category : 'Perspective-Method-View',
	#package : 'Perspective-Method',
	#tag : 'View'
}

{ #category : 'initialization' }
PvMethodProtocolChooserPresenter >> connectPresenters [

	protocolNamePresenter whenTextChangedDo: [ :aString | self filterProtocolsWith: aString ].
	protocolNamePresenter whenSubmitDo: [ :aString | self updateProtocol: aString ].

	"protocolListPresenter outputSelectionPort
		transmitDo: [ :selection | self updateName: selection ]."
	protocolListPresenter outputActivationPort
		transmitDo: [ :selection | self updateProtocol: selection ]
]

{ #category : 'layout' }
PvMethodProtocolChooserPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		borderWidth: 5;
		add: protocolNamePresenter expand: false;
		add: protocolListPresenter;
		yourself
]

{ #category : 'private' }
PvMethodProtocolChooserPresenter >> ensureProtocolExtensionList [

	protocolListKind == #extension ifTrue: [ ^ self ].
	
	protocolListKind := #extension.
	protocolListPresenter items: self extensions
]

{ #category : 'private' }
PvMethodProtocolChooserPresenter >> ensureProtocolList [

	protocolListKind == #protocol ifTrue: [ ^ self ].
	
	protocolListKind := #protocol.
	protocolListPresenter items: self protocols
]

{ #category : 'private' }
PvMethodProtocolChooserPresenter >> extensions [

	^ extensions ifNil: [ 
		extensions := self model allAvailableExtensionNames ]
]

{ #category : 'private' }
PvMethodProtocolChooserPresenter >> filterProtocolsWith: aString [
	"Selects the first that begins with my string (unless this is nil or unclassified)"
	| searchString |
	
	updating ifTrue: [ ^ self ].
	aString ifNil: [ ^ self ].
	
	(aString beginsWith: '*')
		ifTrue: [ self ensureProtocolExtensionList ]
		ifFalse: [ self ensureProtocolList ].	
		
	self updatingWhile: [
		searchString := aString trimBoth asLowercase.
		searchString = Protocol unclassified ifTrue: [ ^ self ].
		
		protocolListPresenter items withIndexDo: [ :each :index |
			(each asLowercase beginsWith: searchString) ifTrue: [
				self updatingWhile: [ 
					protocolListPresenter selectIndex: index scrollToSelection: true ].
				^ self ] ] ]
]

{ #category : 'initialization' }
PvMethodProtocolChooserPresenter >> initialize [

	super initialize.
	updating := false
]

{ #category : 'initialization' }
PvMethodProtocolChooserPresenter >> initializePresenters [

	self addStyle: 'pvProtocolChooser'.
	
	protocolNamePresenter := self newSearchInput.	
	protocolNamePresenter addShortcutWith: [ :action | action 
		shortcutKey: Character escape asKeyCombination;
		action: [ self triggerAbort ] ].
	
	protocolListPresenter := self newEasyListView
]

{ #category : 'events' }
PvMethodProtocolChooserPresenter >> onAbort: aBlock [
	
	abortAction := aBlock
]

{ #category : 'events' }
PvMethodProtocolChooserPresenter >> onSelect: aBlock [
	
	selectAction := aBlock
]

{ #category : 'private' }
PvMethodProtocolChooserPresenter >> protocols [

	^ protocols ifNil: [ 
		protocols := ((self systemNavigation allExistingProtocolsFor: true) 
			reject: [ :each | each beginsWith: '*' ])
			sorted: #asLowercase ascending ]
]

{ #category : 'private' }
PvMethodProtocolChooserPresenter >> triggerAbort [

	abortAction ifNil: [ ^ self ].
	abortAction value
]

{ #category : 'private' }
PvMethodProtocolChooserPresenter >> updateName: aString [
	
	updating ifTrue: [ ^ self ].
	self updatingWhile: [
		protocolNamePresenter text: aString ]
]

{ #category : 'initialization' }
PvMethodProtocolChooserPresenter >> updatePresenter [

	self updatingWhile: [
		self ensureProtocolList.
		self model ifNotNil: [ 
			| protocolName | 
			protocolName := self model protocolName.
			protocolListPresenter selectItem: protocolName.
			protocolNamePresenter text: protocolName.
		 	self application deferToNextCycle: [ 
		 		protocolNamePresenter selectAll ] ] ]
]

{ #category : 'private' }
PvMethodProtocolChooserPresenter >> updateProtocol: aString [
	
	updating ifTrue: [ ^ self ].
	selectAction ifNil: [ ^ self ].
	self updatingWhile: [
		selectAction value: aString ]
]

{ #category : 'private - updating' }
PvMethodProtocolChooserPresenter >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]
