Class {
	#name : 'PulsarSpotterRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'iconPresenter',
		'namePresenter',
		'contextPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'layout' }
PulsarSpotterRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: iconPresenter expand: false;
		add: namePresenter;
		add: contextPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
PulsarSpotterRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarSpotterRow'.
	
	iconPresenter := self newImage.
	namePresenter := self newLabel.
	contextPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself
	
]

{ #category : 'initialization' }
PulsarSpotterRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	
	iconPresenter image: (self iconNamed: (self model iconName ifNil: [ #blank ])).
	namePresenter label: self model label.
	contextPresenter label: self model categoryLabel
]
