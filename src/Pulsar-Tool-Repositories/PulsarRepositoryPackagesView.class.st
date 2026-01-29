Class {
	#name : 'PulsarRepositoryPackagesView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Packages',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Packages'
}

{ #category : 'defaults' }
PulsarRepositoryPackagesView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 1;
		column: 2;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> connectPresenters [
	
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
			action: [ self doAddPackageCommand: action ] ]"; 
		addActionWith: [ :action | action 
			name: 'Load';
			iconName: #load;
			description: 'Load baseline';
			actionEnabled: [ listPresenter selectedItem isBaseline ];
			action: [ ] ]" ]
]

{ #category : 'private - actions' }
PulsarRepositoryPackagesView >> doAddPackageCommand: anAction [
	| result |

	result := self application newSelect
		extent: 300@500;
		title: 'Add package';
		message: 'Select package';
		items: (self model allPackagesAvailableToAdd sorted: #name ascending);
		display: [ :aPackage | aPackage name ];
		displayIcon: [ :aClass | self application iconNamed: 'package' ];
		openModalWithParent: self window.
	result ifNil: [ ^ self ].
	
	self scheduleJob: [
		self model addPackage: result.
		self updatePresenter. 
		self application deferToNextCycle: [
			listPresenter 
				selectItem: result 
				scrollToSelection: true ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryPackagesView >> doInstallBaseline: aPackageModel [
 	| presenter |
 	
 	presenter := self instantiate: PulsarInstallBaselineDialog.
 	(presenter asModalWindow
 		owner: self window;
 		open;
 		isOk)
 		ifFalse: [ ^ self ].
 
 	self scheduleJob: [
 		aPackageModel 
 			installBaselineGroups: presenter groups
 			upgradePolicy: presenter upgradePolicy
 			conflictPolicy: presenter conflictPolicy.
 		self updatePresenter ]
]

{ #category : 'private - actions' }
PulsarRepositoryPackagesView >> doLoadPackage: aPackageModel [
 	| presenter |
 	
 	self scheduleJob: [
 		aPackageModel load.
 		self updatePresenter ]
]

{ #category : 'testing' }
PulsarRepositoryPackagesView >> hasSelectedPackage [

	^ self selectedPackage isNotNil
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> initializePresenters [
	
	self addStyle: 'pulsarRepositoryPackages'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #actions).
	listPresenter := self newFilteringList
		addStyle: 'stList';
		rowPresenterClass: PulsarRepositoryPackageRow;
		display: [ :aPackageModel | aPackageModel name ];
		actions: (SpActionGroup new
			add: self actions;
			addDynamicGroup: #dynamic with: [ :group | group add: self packageActions ];
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Packages'
]

{ #category : 'private' }
PulsarRepositoryPackagesView >> maybeSort: aCollection [

	^ aCollection sort: #isLoaded descending, #isBaseline descending, #name ascending
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> packageActions [

	self hasSelectedPackage ifFalse: [ ^ SpActionGroup new ].

	^ self selectedPackage actionsWithContextOn: self
]

{ #category : 'accessing' }
PulsarRepositoryPackagesView >> selectedPackage [

	^ listPresenter selectedItem
]

{ #category : 'initialization' }
PulsarRepositoryPackagesView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self scheduleJob: [
		listPresenter items: (self maybeSort: self model packages) ]
]
