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
		'updating'
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
PvMethodProtocolChooserPresenter >> filterProtocolsWith: aString [
	"Selects the first that begins with my string (unless this is nil or unclassified)"
	| searchString |

	updating ifTrue: [ ^ self ].
	aString ifNil: [ ^ self ].
	self updatingWhile: [	
		searchString := aString trimmed asLowercase.
		(searchString = Protocol unclassified) ifTrue: [ ^ self ].
		
		protocolListPresenter items withIndexDo: [ :each :index | 
		 	(each asLowercase beginsWith: searchString)
		 		ifTrue: [
		 			self updatingWhile: [
		 				protocolListPresenter 
		 					selectIndex: index 
							scrollToSelection: true ].
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

{ #category : 'private - accessing' }
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
		protocolListPresenter items: self protocols.		
		self model ifNotNil: [ 
			| protocolName | 
			protocolName := self model protocolName.
			protocolListPresenter selectItem: protocolName.
			protocolNamePresenter 
				text: protocolName;
				selectAll ] ]
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
