Class {
	#name : 'DockEntryRowPresenter',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'descriptionPresenter',
		'iconPresenter'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'layout' }
DockEntryRowPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		spacing: 5;
		add: iconPresenter expand: false;
		add: descriptionPresenter;
		yourself
]

{ #category : 'initialization' }
DockEntryRowPresenter >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockChangeEntryRow'.

	iconPresenter := self newImage.
	descriptionPresenter := self newLabel
]

{ #category : 'initialization' }
DockEntryRowPresenter >> updatePresenter [
	| content |
	
	self model ifNil: [ ^ self ].
	content := self model content.
	(content accept: EpIconNameVisitor new) 
		ifNotNil: [ :aName | iconPresenter image: (self iconNamed: aName asString) ].
	(content accept: DockChangeEntryNameVisitor new)
		ifNotNil: [ :aString | descriptionPresenter label: self model asString ]
]
