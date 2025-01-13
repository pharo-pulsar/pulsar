Class {
	#name : 'DockSpotterRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'iconPresenter',
		'namePresenter',
		'contextPresenter'
	],
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'layout' }
DockSpotterRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: iconPresenter expand: false;
		add: namePresenter;
		add: contextPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
DockSpotterRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockSpotterRow'.
	
	iconPresenter := self newImage.
	namePresenter := self newLabel.
	contextPresenter := self newLabel
		addStyle: 'dim';
		addStyle: 'tinyFont';
		yourself
	
]

{ #category : 'initialization' }
DockSpotterRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	
	iconPresenter image: (self iconNamed: (self model iconName ifNil: [ #blank ])).
	namePresenter label: self model label.
	contextPresenter label: self model categoryLabel
]
