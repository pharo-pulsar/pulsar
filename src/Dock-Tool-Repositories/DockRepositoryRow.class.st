Class {
	#name : 'DockRepositoryRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'labelPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'layout' }
DockRepositoryRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: labelPresenter;
		yourself
]

{ #category : 'initialization' }
DockRepositoryRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'dockRepositoryRow'.

	labelPresenter := self newLabel
]

{ #category : 'initialization' }
DockRepositoryRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [
		labelPresenter label: self model name.
		labelPresenter removeAllStyles.
		labelPresenter addStyle: self model status asString ]
]
