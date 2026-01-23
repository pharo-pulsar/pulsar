Class {
	#name : 'PvOutlineRowView',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'iconPresenter',
		'namePresenter',
		'protocolPresenter'
	],
	#category : 'Perspective-Class-View',
	#package : 'Perspective-Class',
	#tag : 'View'
}

{ #category : 'initialization' }
PvOutlineRowView >> colorNamed: aString [

	^ self application colorNamed: aString
]

{ #category : 'layout' }
PvOutlineRowView >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: iconPresenter expand: false;
		add: namePresenter;
		add: protocolPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
PvOutlineRowView >> initializePresenters [

	self addStyle: 'pvOutlineRow'.

	iconPresenter := self newImage.
	namePresenter := self newLabel.
	protocolPresenter := self newLink
]

{ #category : 'initialization' }
PvOutlineRowView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	iconPresenter image: (self iconNamed: self model iconName).
	namePresenter 
		label: self model name;
		displayColor: [ self colorNamed: self model colorName ].
	protocolPresenter label: (self model protocol
		ifNotNil: [ :aProtocol | aProtocol name asString ]
		ifNil: [ '' ])
]
