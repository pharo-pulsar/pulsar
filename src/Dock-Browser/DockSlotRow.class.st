Class {
	#name : 'DockSlotRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'iconPresenter',
		'slotPresenter'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
DockSlotRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		spacing: 3;
		add: namePresenter;
		add: slotPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
DockSlotRow >> initializePresenters [

	namePresenter := self newLabel.
	slotPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself
]

{ #category : 'initialization' }
DockSlotRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter label: self model name.
	slotPresenter label: self model slotName.
]
