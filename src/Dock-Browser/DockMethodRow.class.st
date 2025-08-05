Class {
	#name : 'DockMethodRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
DockMethodRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: namePresenter;
		yourself
]

{ #category : 'initialization' }
DockMethodRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockMethodRow'.

	namePresenter := self newLabel
]

{ #category : 'initialization' }
DockMethodRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter label: self model name
]
