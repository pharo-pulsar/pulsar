Class {
	#name : 'PulsarStackRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'iconPresenter',
		'namePresenter',
		'markPresenter'
	],
	#category : 'Pulsar-Browser-View-Stack',
	#package : 'Pulsar-Browser',
	#tag : 'View-Stack'
}

{ #category : 'layout' }
PulsarStackRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: markPresenter expand: false;
		add: iconPresenter expand: false;
		add: namePresenter;
		yourself
]

{ #category : 'private' }
PulsarStackRow >> editorModel [

	"a model is an editor presenter, it contains a model"
	^ self model model
]

{ #category : 'initialization' }
PulsarStackRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarStackRow'.
	
	markPresenter := self newImage.
	markPresenter hide.
	
	iconPresenter := self newImage.
	namePresenter := self newLabel
]

{ #category : 'private' }
PulsarStackRow >> obtainMarkIcon [

	self model isPinned ifTrue: [ ^ #pin ].
	self model isDirty ifTrue: [ ^ #dirty ].

	^ nil
]

{ #category : 'initialization' }
PulsarStackRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self obtainMarkIcon 
		ifNotNil: [ :aName |
			markPresenter image: (self iconNamed: aName).
			markPresenter show ]
		ifNil: [ 
			markPresenter hide ].
			
	"self model isPinned 
		ifTrue: [ self addStyle: 'pulsarStackRowPinned' ]
		ifFalse: [ self removeStyle: 'pulsarStackRowPinned' ] ."
	
	iconPresenter image: (self iconNamed: self editorModel iconName).
	namePresenter label: self editorModel fullName
]
