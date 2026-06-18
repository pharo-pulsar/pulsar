Class {
	#name : 'PulsarProjectEditor',
	#superclass : 'PulsarBaseView',
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
PulsarProjectEditor class >> defineActionsOn: aBuilder [
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
PulsarProjectEditor >> connectPresenters [

	dependentListPresenter transmitDo: [ :aModel | 
		self updateDependenceWith: aModel ]
]

{ #category : 'api - focus' }
PulsarProjectEditor >> defaultKeyboardFocus [

	^ dependentListPresenter
]

{ #category : 'layout' }
PulsarProjectEditor >> defaultLayout [

	^ SpPanedLayout newHorizontal
		add: (SpBoxLayout newVertical 
			add: dependentListToolbarPresenter expand: false;
			add: dependentListPresenter;
			yourself);
		add: dependencePresenter;
		yourself
]

{ #category : 'private - actions' }
PulsarProjectEditor >> doAddGroup [
]

{ #category : 'private - actions' }
PulsarProjectEditor >> doAddPackage [
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
PulsarProjectEditor >> doAddProject [
]

{ #category : 'initialization' }
PulsarProjectEditor >> initializePanelWidget: aPanelWidgetPresenter [

	super initializePanelWidget: aPanelWidgetPresenter.
	aPanelWidgetPresenter 
		whenPresentedDo: [ self recordLastPresented ];
		whenFocusReceivedDo: [ self notifyEditorActivated ]
]

{ #category : 'initialization' }
PulsarProjectEditor >> initializePresenters [

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
PulsarProjectEditor >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self model name;
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'initialization' }
PulsarProjectEditor >> notifyEditorActivated [

	self notificationCenter announce: (PulsarEditorActivated newValue: self)
]

{ #category : 'initialization' }
PulsarProjectEditor >> toolbarActions [

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
PulsarProjectEditor >> updateDependencePresenterWith: aPresenter [

	self layout second: aPresenter.
	dependencePresenter := aPresenter
]

{ #category : 'private - updating' }
PulsarProjectEditor >> updateDependenceWith: aModel [

	aModel ifNil: [ ^ self ].

	"I turn myself into a visitor to pick the right presenter for this component"
	aModel acceptVisitor: self
]

{ #category : 'initialization' }
PulsarProjectEditor >> updatePresenter [

	dependentListPresenter 
		items: self model dependencyModels.
		
	self withPanelWidgetDo: [ :aWindow | 
		aWindow title: self model name ]
]

{ #category : 'private - updating' }
PulsarProjectEditor >> visitGroupSpec: aMetacelloGroupSpec [

	self updateDependencePresenterWith: ((self instantiate: PulsarEditableListPresenter)
		title: 'Group: ', aMetacelloGroupSpec name;
		items: aMetacelloGroupSpec includes;
		yourself)
]

{ #category : 'private - updating' }
PulsarProjectEditor >> visitPackageSpec: aMetacelloPackageSpec [

	self updateDependencePresenterWith: ((self instantiate: PulsarEditableListPresenter)
		title: 'Requirements of ', aMetacelloPackageSpec name;
		items: aMetacelloPackageSpec requires;
		"whenAddDo: [ ];
		whenRemoveDo: [ ];"
		yourself)
]

{ #category : 'private - updating' }
PulsarProjectEditor >> visitProjectReference: aMetacelloProjectReferenceSpec [
]

{ #category : 'private - updating' }
PulsarProjectEditor >> visitProjectSpec: aMetacelloMCBaselineOfProjectSpec [
]

{ #category : 'private - updating' }
PulsarProjectEditor >> visitVersionSpec: aMetacelloVersionSpec [
]

{ #category : 'private - updating' }
PulsarProjectEditor >> visitVersionSpecChildren: aSpec [
]
