Class {
	#name : 'DockRepositoryPackagesView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'defaults' }
DockRepositoryPackagesView class >> defaultDockPosition [

	^ SpPanelPosition new
		area: SpPanelArea start;
		row: 1;
		column: 2;
		yourself
]

{ #category : 'layout' }
DockRepositoryPackagesView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
DockRepositoryPackagesView >> initializePresenters [

	toolbarPresenter := self instantiate: DockToolbarPresenter.
	listPresenter := self newEasyListView
		display: [ :aPackageModel | aPackageModel name ];
		yourself
]

{ #category : 'initialization' }
DockRepositoryPackagesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Packages'
]

{ #category : 'private' }
DockRepositoryPackagesView >> maybeSort: aCollection [

	^ aCollection sort: #name ascending
]

{ #category : 'initialization' }
DockRepositoryPackagesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	listPresenter items: (self maybeSort: self model packages)
]
