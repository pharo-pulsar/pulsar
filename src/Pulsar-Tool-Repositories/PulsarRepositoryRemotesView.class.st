Class {
	#name : 'PulsarRepositoryRemotesView',
	#superclass : 'PulsarCollectionView',
	#category : 'Pulsar-Tool-Repositories-View-Remotes',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Remotes'
}

{ #category : 'defaults' }
PulsarRepositoryRemotesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 2;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRemotesView >> initializePresenters [

	self addStyle: 'pulsarRepositoryRemotes'.

	listPresenter := self newTable
		addStyle: 'stList';
		addStyle: 'pulsarRemoteList';
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'URL' evaluated: #url);
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryRemotesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Remotes'
]

{ #category : 'initialization' }
PulsarRepositoryRemotesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self scheduleJob: [
		| remotes |
		remotes := self model remotes.
		listPresenter items: remotes ]
]
