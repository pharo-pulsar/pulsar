Class {
	#name : 'DockProjectView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'defaults' }
DockProjectView class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea start;
		row: 1;
		yourself
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionGroupAction: actionGroup [
	<perspectiveActionGroup: #action>
	
	actionGroup 
		name: 'Action';
		priority: 30;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionGroupNew: actionGroup [
	<perspectiveActionGroup: #new>
	
	actionGroup 
		name: 'New';
		priority: 20;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionGroupProject: actionGroup [
	<perspectiveActionGroup: #project>
	
	actionGroup 
		name: 'Project';
		priority: 10;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #project with: { 
			$n mod1		->	PvNewProjectCommand new.
			$o mod1		-> 	PvOpenProjectCommand new.
							PvRefreshProjectCommand new.
		};
		registerGroup: #new with: { 
			PvNewPackageCommand new.
			PvNewPackageTagCommand new.
			DockNewClassCommand new.
			PvNewTraitCommand new
		};
		registerGroup: #action with: { 
			$r mod1 -> PvRenamePackageCommand new.
			$x mod1 -> PvRemovePackageCommand new.
		}
]

{ #category : 'actions' }
DockProjectView >> addProject: aBaselineClass [
	
	self model addProject: aBaselineClass.
	self updatePresenter.
	listPresenter selectPath: { self model children size }
]

{ #category : 'private' }
DockProjectView >> closestEntityInPathMatching: aBlock [

	^ self selectedEntitiesInPath
		ifNotEmpty: [ :entities | entities reversed detect: aBlock ] 
		ifEmpty: [ nil ]
]

{ #category : 'private' }
DockProjectView >> closestPathInPathMatching: aBlock [
	| selectedEntities  |

	selectedEntities := self selectedEntitiesInPath.
	selectedEntities ifNil: [ ^ nil ].
	
	selectedEntities withIndexDo: [ :each : index | 
		(aBlock value: each)
			ifTrue: [ ^ selectedEntities copyFrom: 1 to: index ] ].

	^ nil
]

{ #category : 'api - focus' }
DockProjectView >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
DockProjectView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - actions' }
DockProjectView >> doNewPackage [
	| packageName project package |
	
	packageName := self application newRequest 
		title: 'New package';
		label: 'Package name';
		openModalWithParent: self window.
	packageName ifNil: [ ^ self ].
	
	project := self closestEntityInPathMatching: [ :each | each isProject ].
	project ifNil: [ ^ self ].
	
	package := project addPackageNamed: packageName.
	self updatePresenter.
	listPresenter 
		selectPathByItems: { project. package }
		scrollToSelection: true
]

{ #category : 'private - actions' }
DockProjectView >> doNewPackageTag [
	| packageName parents project package packageTag |
	
	packageName := self application newRequest 
		title: 'New tag';
		label: 'Tag name';
		openModalWithParent: self window.
	packageName ifNil: [ ^ self ].
	
	parents := self closestPathInPathMatching: [ :each | each isPackage ].
	parents ifNil: [ ^ self ].
	
	project := parents first.
	package := parents second.
	
	packageTag := package addPackageTagNamed: packageName.
	self updatePresenter.
	listPresenter 
		selectPathByItems: { project. package. packageTag }
		scrollToSelection: true
]

{ #category : 'private - actions' }
DockProjectView >> doRemoveSelectedEntity [
	"this can be anything on the tree: 
		- project (should I remove from image or just from dock?)
		- package (should I remove from image or just from project?)
		- tag (this one is easy)" 

	listPresenter selectedItem ifNotNil: [ :aModel |
		(DockProjectRemoveModel on: self) visit: aModel realModel ] 
]

{ #category : 'private - actions' }
DockProjectView >> doRequestNewClass [
	| parent |

	parent := self closestEntityInPathMatching: [ :each | each isPackageOrTag ].
	parent ifNil: [ ^ self ].
	
	self notifyActivateEntity: (PvClassModel
		newEnvironment: self model environmentModel 
		beNewClassWithParent: parent)
]

{ #category : 'private - actions' }
DockProjectView >> doRequestNewTrait [

	| parent |

	parent := self closestEntityInPathMatching: [ :each | each isPackageOrTag ].
	parent ifNil: [ ^ self ].
	
	self notifyActivateEntity: (PvClassModel
		newEnvironment: self model environmentModel 
		beNewTraitWithParent: parent)	
]

{ #category : 'events' }
DockProjectView >> eventEditorActivated: anAnnouncement [
	| classModel path |
	
	classModel := anAnnouncement value model asClassModel.
	listPresenter selectedItem realModel = classModel ifTrue: [ ^ self ].
 
	path := self model findPathForClassModel: classModel. 
	path ifNil: [ ^ self ].
	
	listPresenter selectPath: path
]

{ #category : 'initialization' }
DockProjectView >> initializePresenters [

	toolbarPresenter := self instantiate: DockToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #project).	
	toolbarPresenter addPresenter: (self newMenuButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'menu');
		actions: (self actions actionsFor: #new);
		yourself).

	listPresenter := self newEntityTree.
	listPresenter addStyle: 'dockProjectTree'.
	
	listPresenter addShortcutWith: [ :act | act 
		shortcutKey: Character arrowRight alt;
		action: [ self maybeOpenFlyView ] ]
]

{ #category : 'initialization' }
DockProjectView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Project'
]

{ #category : 'private - actions' }
DockProjectView >> maybeOpenFlyView [

	self halt
]

{ #category : 'initialization' }
DockProjectView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: DockEditorActivated send: #eventEditorActivated: to: self	
]

{ #category : 'private - actions' }
DockProjectView >> removeProjectModel: aProjectModel [

	self model removeProjectModel: aProjectModel.
	self updatePresenter
]

{ #category : 'private' }
DockProjectView >> selectedEntitiesInPath [

	^ listPresenter selection selectedItemsInPath

]

{ #category : 'private' }
DockProjectView >> toolbarPresenter [

	^ toolbarPresenter
]

{ #category : 'initialization' }
DockProjectView >> updatePresenter [

	self model ifNil: [ 
		listPresenter roots: #().
		^ self ].
	
	listPresenter 
		roots: (self model children copyWith: self model environmentModel);
		expandPath: #(1)
]
