Class {
	#name : 'PulsarProjectNodeRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'imagePresenter',
		'labelPresenter'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'layout' }
PulsarProjectNodeRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: imagePresenter expand: false;
		add: labelPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarProjectNodeRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarProjectNodeRow'.

	imagePresenter := self newImage.
	labelPresenter := self newLabel
]

{ #category : 'initialization' }
PulsarProjectNodeRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self model iconName 
		ifNotNil: [ :aName | imagePresenter show; image: (self iconNamed: aName) ]
		ifNil: [ imagePresenter hide ].
	labelPresenter label: self model name.
	
	"self model isManagedAndModified
		ifTrue: [ labelPresenter addStyle: 'modified' ]
		ifFalse: [ labelPresenter removeStyle: 'modified' ]"
]
