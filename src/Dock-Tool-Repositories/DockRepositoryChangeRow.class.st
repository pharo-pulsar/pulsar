Class {
	#name : 'DockRepositoryChangeRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'checkBoxPresenter',
		'labelPresenter',
		'imagePresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'initialization' }
DockRepositoryChangeRow >> connectPresenters [

	checkBoxPresenter whenChangedDo: [ :active | 
		self application defer: [
			self model toggleActivateBranch: active ] ]
]

{ #category : 'layout' }
DockRepositoryChangeRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: checkBoxPresenter expand: false;
		add: imagePresenter expand: false;
		add: labelPresenter;
		yourself
]

{ #category : 'initialization' }
DockRepositoryChangeRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockRepositoryChangeRow'.
	
	checkBoxPresenter := self newCheckBox.
	imagePresenter := self newImage.
	labelPresenter := self newLabel
]

{ #category : 'accessing - model' }
DockRepositoryChangeRow >> model: aDiffNode [

	model ifNotNil: [ model resetStateChangedAction ].
	super model: aDiffNode.
	aDiffNode whenStateChangedDo: [ :aValue | 
		self updateActiveStatus: aValue ]
]

{ #category : 'initialization' }
DockRepositoryChangeRow >> updateActiveStatus: aBoolean [

	checkBoxPresenter state: aBoolean
]

{ #category : 'initialization' }
DockRepositoryChangeRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	checkBoxPresenter state: self model isActive.
	imagePresenter image: (self iconNamed: self model iconName).
	labelPresenter label: self model description
]
