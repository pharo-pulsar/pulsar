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

	iconPresenter := self newImage.
	namePresenter := self newLabel.
	countPresenter := self newLabel
		addStyle: 'dim';
		yourself
]

{ #category : 'initialization' }
DockProtocolRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	iconPresenter image: (self model iconComposite buildOn: self application).
	namePresenter label: self model name.
	countPresenter label: (self model numberOfMethods 
		ifNotNil: [ :aNumber | aNumber asString ]
		ifNil: [ '' ]).
]
