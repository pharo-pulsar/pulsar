Class {
	#name : 'PulsarRepositoryBaseBranchView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'toolbarActions'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> branches [

	self subclassResponsibility
]

{ #category : 'layout' }
PulsarRepositoryBaseBranchView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> entitySelected: anEntity [

	self updateToolbar.
	"super entitySelected: anEntity."
]

{ #category : 'initialization' }
PulsarRepositoryBaseBranchView >> initializePresenters [

	self addStyle: 'pulsarRepositoryBranch'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter. 
	toolbarPresenter actions: self toolbarActions.

	listPresenter := self newEasyListView
		addStyle: 'stList';
		rowPresenterClass: PulsarRepositoryBranchRow;
		display: [ :aBranchModel | aBranchModel name ];
		yourself
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> maybeSort: aCollection [

	^ aCollection
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> selectedItemName [

	^ self selectedItem 
		ifNotNil: [ :each | each name ]
		ifNil: [ 'Unknown' ]
]

{ #category : 'initialization' }
PulsarRepositoryBaseBranchView >> toolbarActions [

	^ toolbarActions ifNil: [ toolbarActions := self actions actionsFor: #gitActions ]
]

{ #category : 'initialization' }
PulsarRepositoryBaseBranchView >> updatePresenter [

	self model ifNil: [ ^ self ].

	self withWindowDo: #jobStart.
	self application scheduleTask: [
		[
			| branches |
			branches := self maybeSort: self branches.
			self application 
				defer: [ listPresenter items: branches ] ] 
		ensure: [ 
			self withWindowDo: #jobEnd ] ]
]

{ #category : 'private' }
PulsarRepositoryBaseBranchView >> updateToolbar [

	toolbarActions allCommands do: [ :each | each updateEnableStatus ]
]
