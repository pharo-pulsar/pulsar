Class {
	#name : 'PulsarRepositoryPackageRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'layout' }
PulsarRepositoryPackageRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: namePresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryPackageRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarRepositoryPackageRow'.

	namePresenter := self newLabel
]

{ #category : 'initialization' }
PulsarRepositoryPackageRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [ 
		namePresenter label: self model name.
		namePresenter removeAllStyles.
		self model isLoaded 
			ifTrue: [ namePresenter addStyle: 'loaded' ]
			ifFalse: [ namePresenter addStyle: 'notloaded' ] ]
]
