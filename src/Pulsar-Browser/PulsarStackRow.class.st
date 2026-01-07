Class {
	#name : 'PulsarStackRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'iconPresenter',
		'namePresenter'
	],
	#category : 'Pulsar-Browser-View-Stack',
	#package : 'Pulsar-Browser',
	#tag : 'View-Stack'
}

{ #category : 'layout' }
PulsarStackRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: iconPresenter expand: false;
		add: namePresenter;
		yourself
]

{ #category : 'initialization' }
PulsarStackRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockStackRow'.
	
	iconPresenter := self newImage.
	namePresenter := self newLabel
]

{ #category : 'initialization' }
PulsarStackRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	iconPresenter image: (self model iconComposite buildOn: self application).
	namePresenter label: self model fullName
]
