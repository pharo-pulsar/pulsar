Class {
	#name : 'PulsarProjectNodeRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#traits : 'PulsarTModelVisitor',
	#classTraits : 'PulsarTModelVisitor classTrait',
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
	
	self application defer: [
		self model iconName 
			ifNotNil: [ :aName | imagePresenter show; image: (self iconNamed: aName) ]
			ifNil: [ imagePresenter hide ].
		
		labelPresenter label: self model name.
		self model accept: self ]
]

{ #category : 'visiting' }
PulsarProjectNodeRow >> visitClassModel: aModel [

	labelPresenter removeAllStyles.
	aModel isDeprecated ifTrue: [
		labelPresenter addStyle: 'deprecated' ]
]
