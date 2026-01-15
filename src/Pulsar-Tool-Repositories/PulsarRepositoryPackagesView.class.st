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
PulsarRepositoryPackagesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
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

{ #category : 'private - definitions' }
PulsarRepositoryPackagesView >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #actions with: [ :group | group 
		addActionWith: [ :action | action 
			name: 'Add Package';
			iconName: #add;
			description: 'Add a Package';
			action: [ ] ]"; 
		addActionWith: [ :action | action 
			name: 'Load';
			iconName: #load;
			description: 'Load baseline';
			actionEnabled: [ listPresenter selectedItem isBaseline ];
			action: [ ] ]" ]
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> initializePresenters [

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #actions).
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
