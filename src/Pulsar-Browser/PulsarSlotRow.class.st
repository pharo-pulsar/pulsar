Class {
	#name : 'PulsarSlotRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'iconPresenter',
		'slotPresenter'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
PulsarSlotRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		spacing: 3;
		add: namePresenter;
		add: slotPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
PulsarSlotRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockSlotRow'.

	namePresenter := self newLabel.
	slotPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself
]

{ #category : 'initialization' }
PulsarSlotRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter label: self model name.
	slotPresenter label: self model slotName.
]
