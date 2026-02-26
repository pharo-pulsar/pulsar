Class {
	#name : 'PulsarStackRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'iconPresenter',
		'namePresenter',
		'pinnedPresenter',
		'dirtyPresenter'
	],
	#category : 'Pulsar-Browser-View-Stack',
	#package : 'Pulsar-Browser',
	#tag : 'View-Stack'
}

{ #category : 'layout' }
PulsarStackRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: dirtyPresenter expand: false;
		add: pinnedPresenter expand: false;
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
	
	pinnedPresenter := self newImage
		addStyle: 'button';
		image: (self iconNamed: #pin);
		help: 'Unpin this editor';
		yourself.
	pinnedPresenter hide.
	pinnedPresenter eventHandler whenMouseDownDo: [ :event | self unpin ].
	
	dirtyPresenter := self newImage
		image: (self iconNamed: 'dirty');
		yourself.
	dirtyPresenter hide.	
	
	iconPresenter := self newImage.
	namePresenter := self newLabel
]

{ #category : 'private' }
PulsarStackRow >> obtainMarkIcon [

	self model isPinned ifTrue: [ ^ #pin ].
	self model isDirty ifTrue: [ ^ #dirty ].

	^ nil
]

{ #category : 'private - actions' }
PulsarStackRow >> unpin [

	self listView announcer announce: (PulsarStackUnpinEditor newEditor: self model)
]

{ #category : 'initialization' }
PulsarStackRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self verifyPinnedStatus.
	self verifyDirtyStatus.
	
	iconPresenter image: (self iconNamed: self editorModel iconName).
	namePresenter label: self editorModel fullName
]

{ #category : 'initialization' }
PulsarStackRow >> verifyDirtyStatus [

	dirtyPresenter visible: self model isDirty
]

{ #category : 'initialization' }
PulsarStackRow >> verifyPinnedStatus [

	pinnedPresenter visible: self model isPinned
]
