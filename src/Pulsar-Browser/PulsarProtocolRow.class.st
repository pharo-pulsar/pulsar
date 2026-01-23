Class {
	#name : 'PulsarProtocolRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'countPresenter',
		'iconPresenter'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
PulsarProtocolRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		spacing: 3;
		add: iconPresenter expand: false;
		add: namePresenter;
		add: countPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
PulsarProtocolRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarProtocolRow'.

	iconPresenter := self newImage.
	namePresenter := self newLabel.
	countPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself
]

{ #category : 'initialization' }
PulsarProtocolRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	iconPresenter image: (self iconNamed: self model iconName).
	namePresenter label: self model name.
	self model isUnclassified
		ifTrue: [ namePresenter addStyle: 'unclassified' ]
		ifFalse: [ namePresenter removeStyle: 'unclassified' ].
	countPresenter label: (self model numberOfMethods 
		ifNotNil: [ :aNumber | aNumber asString ]
		ifNil: [ '' ]).
]
