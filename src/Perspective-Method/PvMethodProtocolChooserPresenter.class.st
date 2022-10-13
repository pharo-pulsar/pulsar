Class {
	#name : #PvMethodProtocolChooserPresenter,
	#superclass : #SpPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'protocolNamePresenter',
		'protocolListPresenter',
		'selectAction'
	],
	#category : #'Perspective-Method-View'
}

{ #category : #layout }
PvMethodProtocolChooserPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		borderWidth: 5;
		add: protocolNamePresenter expand: false;
		add: protocolListPresenter;
		yourself
]

{ #category : #layout }
PvMethodProtocolChooserPresenter >> initializePresenters [

	self addStyle: 'pvProtocolChooser'.
	
	protocolNamePresenter := self newTextInput.
	protocolNamePresenter whenTextChangedDo: [ :text | ].
	protocolNamePresenter whenSubmitDo: [ :aString | self updateProtocol: aString ].
	
	protocolListPresenter := self newList.
	protocolListPresenter outputSelectionPort
		transmitTo: protocolNamePresenter defaultInputPort.
	protocolListPresenter outputActivationPort
		transmitDo: [ :selection | self updateProtocol: selection ]
]

{ #category : #events }
PvMethodProtocolChooserPresenter >> onSelect: aBlock [
	
	selectAction := aBlock
]

{ #category : #'private - accessing' }
PvMethodProtocolChooserPresenter >> protocols [

	^ ((self systemNavigation allExistingProtocolsFor: true) 
		reject: [ :each | each beginsWith: '*' ])
		sorted: #asLowercase ascending
]

{ #category : #initialization }
PvMethodProtocolChooserPresenter >> updatePresenter [

	protocolListPresenter items: self protocols.
	
	self model ifNotNil: [ 
		protocolListPresenter selectItem: self model protocol.
		protocolNamePresenter 
			text: self model protocol;
			selectAll ]
]

{ #category : #private }
PvMethodProtocolChooserPresenter >> updateProtocol: aString [
	
	selectAction ifNil: [ ^ self ].
	selectAction value: aString
]
