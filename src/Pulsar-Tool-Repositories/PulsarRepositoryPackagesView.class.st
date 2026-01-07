Class {
	#name : 'PulsarRepositoryPackagesView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'defaults' }
PulsarRepositoryPackagesView class >> defaultPulsarPosition [

	^ SpPanelPosition new
		area: SpPanelArea start;
		row: 1;
		column: 2;
		yourself
]

{ #category : 'layout' }
PulsarRepositoryPackagesView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> initializePresenters [

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	listPresenter := self newEasyListView
		display: [ :aPackageModel | aPackageModel name ];
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Packages'
]

{ #category : 'private' }
PulsarRepositoryPackagesView >> maybeSort: aCollection [

	^ aCollection sort: #name ascending
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	listPresenter items: (self maybeSort: self model packages)
]
