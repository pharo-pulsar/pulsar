Class {
	#name : 'DockProjectEditor',
	#superclass : 'DockBaseView',
	#traits : 'DockTPanelWindow',
	#classTraits : 'DockTPanelWindow classTrait',
	#instVars : [
		'dependentListPresenter',
		'dependencePresenter',
		'dependentListToolbarPresenter'
	],
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing - actions' }
DockProjectEditor class >> defineActionGroupNew: actionGroup [
	<perspectiveActionGroup: #new>
	
	actionGroup 
		name: 'New';
		priority: 20;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
DockProjectEditor class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder registerGroup: #new with: { 
		SpAction new
			name: 'Add package';
			description: 'Add a package';
			action: [ :aContext | aContext doAddPackage ].		
		SpAction new
			name: 'Add project';
			description: 'Add a dependent project';
			action: [ :aContext | aContext doAddProject ].		
		SpAction new
			name: 'Add group';
			description: 'Add a group';
			action: [ :aContext | aContext doAddGroup ].		
		}

]

{ #category : 'initialization' }
DockProjectEditor >> connectPresenters [

	dependentListPresenter transmitDo: [ :aModel | 
		self updateDependenceWith: aModel ]
]

{ #category : 'api - focus' }
DockProjectEditor >> defaultKeyboardFocus [

	^ dependentListPresenter
]

{ #category : 'layout' }
DockProjectEditor >> defaultLayout [

	^ SpPanedLayout newHorizontal
		add: (SpBoxLayout newVertical 
			add: dependentListToolbarPresenter expand: false;
			add: dependentListPresenter;
			yourself);
		add: dependencePresenter;
		yourself
]

{ #category : 'private - actions' }
DockProjectEditor >> doAddGroup [
]

{ #category : 'private - actions' }
DockProjectEditor >> doAddPackage [
	| result |
	
	result := self application newSelect
		title: 'Add package';
		label: 'Select package';
		items: (PackageOrganizer default packages sorted: #name ascending);
		display: [ :aPackage | aPackage name ];
		openModalWithParent: self window.
		
	result ifNil: [ ^ self ].
	self halt
]

{ #category : 'private - actions' }
DockProjectEditor >> doAddProject [
]

{ #category : 'initialization' }
DockProjectEditor >> initializePresenters [

	self addStyle: 'dockProjectEditor'.
	
	dependentListToolbarPresenter := self instantiate: DockToolbarPresenter.
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
DockProjectEditor >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self model name;
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'initialization' }
DockProjectEditor >> notifyEditorActivated [

	self notificationCenter announce: (DockEditorActivated newValue: self)
]

{ #category : 'initialization' }
DockProjectEditor >> toolbarActions [

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
DockProjectEditor >> updateDependencePresenterWith: aPresenter [

	self layout second: aPresenter.
	dependencePresenter := aPresenter
]

{ #category : 'private - updating' }
DockProjectEditor >> updateDependenceWith: aModel [

	aModel ifNil: [ ^ self ].

	"I turn myself into a visitor to pick the right presenter for this component"
	aModel acceptVisitor: self
]

{ #category : 'initialization' }
DockProjectEditor >> updatePresenter [

	dependentListPresenter 
		items: self model dependencyModels.
		
	self withPanelWindowDo: [ :aWindow | 
		aWindow title: self model name ]
]

{ #category : 'private - updating' }
DockProjectEditor >> visitGroupSpec: aMetacelloGroupSpec [

	self updateDependencePresenterWith: ((self instantiate: DockEditableListPresenter)
		title: 'Group: ', aMetacelloGroupSpec name;
		items: aMetacelloGroupSpec includes;
		yourself)
]

{ #category : 'private - updating' }
DockProjectEditor >> visitPackageSpec: aMetacelloPackageSpec [

	self updateDependencePresenterWith: ((self instantiate: DockEditableListPresenter)
		title: 'Requirements of ', aMetacelloPackageSpec name;
		items: aMetacelloPackageSpec requires;
		"whenAddDo: [ ];
		whenRemoveDo: [ ];"
		yourself)
]

{ #category : 'private - updating' }
DockProjectEditor >> visitProjectReference: aMetacelloProjectReferenceSpec [
]

{ #category : 'private - updating' }
DockProjectEditor >> visitProjectSpec: aMetacelloMCBaselineOfProjectSpec [
]

{ #category : 'private - updating' }
DockProjectEditor >> visitVersionSpec: aMetacelloVersionSpec [
]

{ #category : 'private - updating' }
DockProjectEditor >> visitVersionSpecChildren: aSpec [
]
