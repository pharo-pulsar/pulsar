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
		add: iconPresenter expand: false;
		add: descriptionPresenter;
		yourself
]

{ #category : 'initialization' }
DockEntryRowPresenter >> initializePresenters [

	iconPresenter := self newImage.
	descriptionPresenter := self newLabel
]

{ #category : 'initialization' }
DockEntryRowPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	(self model content accept: EpIconNameVisitor new) 
		ifNotNil: [ :aName | iconPresenter image: (self iconNamed: aName asString) ].
	descriptionPresenter label: self model asString
]
