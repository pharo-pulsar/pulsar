Class {
	#name : 'DockStackRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'iconPresenter',
		'namePresenter'
	],
	#category : 'Dock-Browser-View-Stack',
	#package : 'Dock-Browser',
	#tag : 'View-Stack'
}

{ #category : 'layout' }
DockStackRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: iconPresenter expand: false;
		add: namePresenter;
		yourself
]

{ #category : 'initialization' }
DockStackRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockStackRow'.
	
	iconPresenter := self newImage.
	namePresenter := self newLabel
]

{ #category : 'initialization' }
DockStackRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	iconPresenter image: (self model iconComposite buildOn: self application).
	namePresenter label: self model fullName
]
