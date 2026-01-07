Class {
	#name : 'PulsarEntryRowPresenter',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'descriptionPresenter',
		'iconPresenter'
	],
	#category : 'Pulsar-Tool-Changes',
	#package : 'Pulsar-Tool-Changes'
}

{ #category : 'layout' }
PulsarEntryRowPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		spacing: 5;
		add: iconPresenter expand: false;
		add: descriptionPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarEntryRowPresenter >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockChangeEntryRow'.

	iconPresenter := self newImage.
	descriptionPresenter := self newLabel useMarkup
]

{ #category : 'initialization' }
PulsarEntryRowPresenter >> updatePresenter [
	| content |
	
	self model ifNil: [ ^ self ].
	content := self model content.
	(content accept: EpIconNameVisitor new) 
		ifNotNil: [ :aName | iconPresenter image: (self iconNamed: aName asString) ].
	(content accept: PulsarChangeEntryNameVisitor new)
		ifNotNil: [ :aString | descriptionPresenter label: aString ]
]
