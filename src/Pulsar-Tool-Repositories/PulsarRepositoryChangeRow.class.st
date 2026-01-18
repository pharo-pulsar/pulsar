Class {
	#name : 'PulsarRepositoryChangeRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'checkBoxPresenter',
		'labelPresenter',
		'imagePresenter'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'initialization' }
PulsarRepositoryChangeRow >> connectPresenters [

	checkBoxPresenter whenChangedDo: [ :active | 
		self application defer: [
			self model toggleActivateBranch: active ] ]
]

{ #category : 'layout' }
PulsarRepositoryChangeRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: checkBoxPresenter expand: false;
		add: imagePresenter expand: false;
		add: labelPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryChangeRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarRepositoryChangeRow'.
	
	checkBoxPresenter := self newCheckBox.
	imagePresenter := self newImage.
	labelPresenter := self newLabel
]

{ #category : 'accessing - model' }
PulsarRepositoryChangeRow >> model: aDiffNode [

	model ifNotNil: [ model resetStateChangedAction ].
	super model: aDiffNode.
	aDiffNode whenStateChangedDo: [ :aValue | 
		self updateActiveStatus: aValue ]
]

{ #category : 'initialization' }
PulsarRepositoryChangeRow >> updateActiveStatus: aBoolean [

	checkBoxPresenter state: aBoolean
]

{ #category : 'initialization' }
PulsarRepositoryChangeRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	checkBoxPresenter state: self model isActive.
	imagePresenter image: (self iconNamed: self model iconName).
	labelPresenter label: self model description
]
