Class {
	#name : 'DockProjectView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter',
		'mutex'
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
DockProjectView class >> defineActionGroupRefactors: actionGroup [
	<perspectiveActionGroup: #refactors>
	
	actionGroup 
		name: 'Refactors';
		priority: 900;
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
		};
		registerGroup: #refactors with: {
			PvAction new 
				name: 'Duplicate class'; 
				"actionEnabled: [ :aContext | aContext selectedItem isClassModel ];"
				action: [ :aContext | aContext doDuplicateSelectedClass ]
		}
]

{ #category : 'actions' }
DockProjectView >> addProject: aBaselineClass [
	| path |
	
	self model addProject: aBaselineClass.
	self updateListPresenterExpanding: nil.
	
	path := { self model children size }.
	listPresenter
		selectPath: path;
		expandPath: path;
		takeKeyboardFocus.

	self withWindowDo: [ :aWindow | aWindow updateTitle ]
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
DockProjectView >> doDuplicateSelectedClass [	
	| dialog duplicateName |

	dialog := self instantiate: DockRequestPresenter.
	dialog label: 'New class name'.
	dialog acceptLabel: 'Duplicate'.
	
	dialog asPopover
		"relativeTo: aCommand presenter;"
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].
	
	duplicateName := dialog text.
	
	listPresenter selectedItem realModel duplicateAs: duplicateName.
	
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
DockProjectView >> doNewProject [
	| projectName project package |
	
	projectName := self application newRequest 
		title: 'New project';
		label: 'Project name';
		openModalWithParent: self window.
	projectName ifNil: [ ^ self ].
	
	project := self model newProjectNamed: projectName.
	self addProject: project.
	self notifyActivateEntity: (self listPresenter roots detect: [ :each | each entity = project ])
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
	(listPresenter selectedItem isNotNil and: [ listPresenter selectedItem realModel = classModel ]) 
		ifTrue: [ ^ self ].
 
	path := self model findPathForClassModel: classModel. 
	path ifNil: [ ^ self ].
	
	mutex critical: [
		listPresenter selectPath: path ]
]

{ #category : 'initialization' }
DockProjectView >> initialize [

	mutex := Mutex new.
	super initialize
]

{ #category : 'initialization' }
DockProjectView >> initializePresenters [
	self addStyle: 'dockProjectView'.

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

{ #category : 'accessing' }
DockProjectView >> openedProjects [

	^ self model children
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
	self updatePresenter.
	self withWindowDo: [ :aWindow | aWindow updateTitle ]
]

{ #category : 'private' }
DockProjectView >> selectedEntitiesInPath [

	^ listPresenter selection selectedItemsInPath

]

{ #category : 'accessing - snapshot' }
DockProjectView >> snapshot [

	^ DockProjectSnapshot on: self
]

{ #category : 'private' }
DockProjectView >> toolbarPresenter [

	^ toolbarPresenter
]

{ #category : 'initialization' }
DockProjectView >> updateListPresenterExpanding: aPath [
	mutex critical: [
		listPresenter roots: (self model children copyWith: self model environmentModel).
	aPath ifNotNil: [
		listPresenter expandPath: aPath ] ]
]

{ #category : 'initialization' }
DockProjectView >> updatePresenter [

	self model ifNil: [ 
		listPresenter roots: #().
		^ self ].
	
	self updateListPresenterExpanding: #(1)
]
