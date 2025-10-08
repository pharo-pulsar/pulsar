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
		
	self application defer: [
		namePresenter label: self model name.
		namePresenter removeAllStyles.
		self model decorators
			reject: [ :each | each style isNil ]
			thenDo: [ :each | namePresenter addStyle: each style ] ]
]
