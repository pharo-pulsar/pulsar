Class {
	#name : 'PulsarProjectDependenciesPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTActionContainer',
	#classTraits : 'SpTModel classTrait + PulsarTActionContainer classTrait',
	#instVars : [
		'dependentListPresenter',
		'dependencePresenter',
		'dependentListToolbarPresenter'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing - actions' }
PulsarProjectDependenciesPresenter class >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #new with: [ :group | group
		priority: 20;
		name: 'New';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			name: 'Add package';
			description: 'Add a package';
			action: [ :aContext | aContext doAddPackage ] ];
		addActionWith: [ :action | action
			name: 'Add project';
			description: 'Add a dependent project';
			action: [ :aContext | aContext doAddProject ] ];
		addActionWith: [ :action | action
			name: 'Add group';
			description: 'Add a group';
			action: [ :aContext | aContext doAddGroup ] ] ]
]

{ #category : 'initialization' }
PulsarProjectDependenciesPresenter >> connectPresenters [

	dependentListPresenter transmitDo: [ :aModel | self updateDependenceWith: aModel ]
]

{ #category : 'api - focus' }
PulsarProjectDependenciesPresenter >> defaultKeyboardFocus [

	^ dependentListPresenter
]

{ #category : 'layout' }
PulsarProjectDependenciesPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal
		add: (SpBoxLayout newVertical
			add: dependentListToolbarPresenter expand: false;
			add: dependentListPresenter;
			yourself);
		add: dependencePresenter;
		yourself
]

{ #category : 'private - actions' }
PulsarProjectDependenciesPresenter >> doAddGroup [

	
]

{ #category : 'private - actions' }
PulsarProjectDependenciesPresenter >> doAddPackage [
	| result |
	
	result := self application newSelect
		title: 'Add package';
		message: 'Select package';
		items: (PackageOrganizer default packages sorted: #name ascending);
		display: [ :aPackage | aPackage name ];
		openModalWithParent: self window.

	result ifNil: [ ^ self ].
	self halt
]

{ #category : 'private - actions' }
PulsarProjectDependenciesPresenter >> doAddProject [

	
]

{ #category : 'initialization' }
PulsarProjectDependenciesPresenter >> initializePresenters [

	self addStyle: 'pulsarProjectEditor'.

	dependentListToolbarPresenter := self instantiate: PulsarToolbarPresenter.
	dependentListToolbarPresenter addPresenter: (self newMenuButton
		addStyle: 'flat';
		icon: (self iconNamed: 'menu');
		actions: (self actions actionsFor: #new);
		yourself).

	dependentListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :aSpec | aSpec name ];
		displayIcon: [ :aSpec | self application iconNamed: aSpec iconName ];
		yourself.

	dependencePresenter := self newCode beForScripting
]

{ #category : 'initialization' }
PulsarProjectDependenciesPresenter >> toolbarActions [

	^ SpActionGroup new
		addGroupWith: [ :group | group
			name: 'New';
			iconName: #more;
			addActionWith: [ :action | action
				name: 'Add';
				description: 'Add a new element';
				iconName: #add;
				action: [ self doAdd ] ] ];
		yourself
]

{ #category : 'private - updating' }
PulsarProjectDependenciesPresenter >> updateDependencePresenterWith: aPresenter [

	self layout second: aPresenter.
	dependencePresenter := aPresenter
]

{ #category : 'private - updating' }
PulsarProjectDependenciesPresenter >> updateDependenceWith: aModel [

	aModel ifNil: [ ^ self ].

	aModel acceptVisitor: self
]

{ #category : 'initialization' }
PulsarProjectDependenciesPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	dependentListPresenter items: self model dependencyModels
]

{ #category : 'private - updating' }
PulsarProjectDependenciesPresenter >> visitGroupSpec: aMetacelloGroupSpec [

	self updateDependencePresenterWith: ((self instantiate: PulsarEditableListPresenter)
		title: 'Group: ' , aMetacelloGroupSpec name;
		items: aMetacelloGroupSpec includes;
		yourself)
]

{ #category : 'private - updating' }
PulsarProjectDependenciesPresenter >> visitPackageSpec: aMetacelloPackageSpec [

	self updateDependencePresenterWith: ((self instantiate: PulsarEditableListPresenter)
		title: 'Requirements of ' , aMetacelloPackageSpec name;
		items: aMetacelloPackageSpec requires;
		yourself)
]

{ #category : 'private - updating' }
PulsarProjectDependenciesPresenter >> visitProjectReference: aMetacelloProjectReferenceSpec [

	
]

{ #category : 'private - updating' }
PulsarProjectDependenciesPresenter >> visitProjectSpec: aMetacelloMCBaselineOfProjectSpec [

	
]

{ #category : 'private - updating' }
PulsarProjectDependenciesPresenter >> visitVersionSpec: aMetacelloVersionSpec [

	
]

{ #category : 'private - updating' }
PulsarProjectDependenciesPresenter >> visitVersionSpecChildren: aSpec [

	
]
