Class {
	#name : 'PulsarMethodRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
PulsarMethodRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: namePresenter;
		yourself
]

{ #category : 'initialization' }
PulsarMethodRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarMethodRow'.

	namePresenter := self newLabel
]

{ #category : 'initialization' }
PulsarMethodRow >> updatePresenter [

	self model ifNil: [ ^ self ].
		
	self application defer: [
		namePresenter label: self model name.
		namePresenter removeAllStyles.
		self model decorators
			reject: [ :each | each style isNil ]
			thenDo: [ :each | namePresenter addStyle: each style ] ]
]
