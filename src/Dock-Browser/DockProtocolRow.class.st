Class {
	#name : 'DockProtocolRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'countPresenter',
		'iconPresenter'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
DockProtocolRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		spacing: 3;
		add: iconPresenter expand: false;
		add: namePresenter;
		add: countPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
DockProtocolRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockProtocolRow'.

	iconPresenter := self newImage.
	namePresenter := self newLabel.
	countPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself
]

{ #category : 'initialization' }
DockProtocolRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	iconPresenter image: (self model iconComposite buildOn: self application).
	namePresenter label: self model name.
	self model isUnclassified
		ifTrue: [ namePresenter addStyle: 'unclassified' ]
		ifFalse: [ namePresenter removeStyle: 'unclassified' ].
	countPresenter label: (self model numberOfMethods 
		ifNotNil: [ :aNumber | aNumber asString ]
		ifNil: [ '' ]).
]
