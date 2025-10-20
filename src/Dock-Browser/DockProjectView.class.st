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
DockProjectView class >> defineActionGroupExtra: actionGroup [
	<perspectiveActionGroup: #extra>
	
	actionGroup 
		name: 'Actions';
		priority: 30;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionGroupNew: actionGroup [
	<perspectiveActionGroup: #new>
	
	actionGroup 
		name: 'New';
		priority: 20;
		beDisplayedAsGroup
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
			PvNewTraitCommand new.
		};
		registerGroup: #action with: { 
			$r mod1 -> PvRenamePackageCommand new.
			$x mod1 -> PvRemovePackageCommand new.
		};
		registerGroup: #refactors with: {
			SpAction new 
				name: 'Duplicate class'; 
				"actionEnabled: [ :aContext | aContext selectedItem isClassModel ];"
				action: [ :aContext | aContext doDuplicateSelectedClass ]
		};
		registerGroup: #extra with: { 
			SpAction new 
				name: 'Collapse All';
				description: 'Collapses all open projects';
				iconName: 'collapse-all';
				action: [ :aContext | aContext doCollapseAll ].
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
DockProjectView >> doCollapseAll [

	listPresenter 
		unselectAll;
		collapseAll
]

{ #category : 'private - actions' }
DockProjectView >> doDuplicateSelectedClass [	
	| dialog duplicateName |

	dialog := self instantiate: DockRequestPresenter.
	dialog label: 'New class name'.
	dialog acceptLabel: 'Duplicate'.
	
	dialog asPopover
		relativeTo: (self listPresenter selectedRowPresenter ifNil: [ self listPresenter ]);
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

{ #category : 'events - system' }
DockProjectView >> eventBehaviorAdded: anAnnouncement [
	| classAdded path |
	
	"not working for the moment"	
	true ifTrue: [ ^ self ].
	
	classAdded := anAnnouncement classAdded.
	logger trace: classAdded.
	
	path := self model findPathForPackage: classAdded package.
	logger trace: path.
	logger trace: (listPresenter isExpanded: path).
	
	"(listPresenter isExpanded: path) ifTrue: [
		mutex critical: [
			self application defer: [
				listPresenter 
					collapsePath: path; 
					expandPath: path ] ] ]"
]

{ #category : 'events - system' }
DockProjectView >> eventBehaviorRemoved: anAnnouncement [
	| classRemoved path |

	"not working for the moment"	
	true ifTrue: [ ^ self ].
	
	classRemoved := anAnnouncement classRemoved.
	logger trace: classRemoved.
	
	path := self model findPathForPackage: classRemoved package.
	logger trace: path.
	
	"this is lame, I need to find a way to refresh without recalculate"
	"(listPresenter isExpanded: path) ifTrue: [
		mutex critical: [
			self application defer: [
				listPresenter 
					collapsePath: path; 
					expandPath: path ] ] ]"
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

{ #category : 'events - system' }
DockProjectView >> eventMethodModified: anAnnouncement [
	"why this is still here?"
]

{ #category : 'events - system' }
DockProjectView >> eventPackageAdded: anAnnouncement [

	logger trace: anAnnouncement package
]

{ #category : 'initialization' }
DockProjectView >> initialize [

	mutex := Mutex new.
	super initialize.
	self registerToSystemEvents
]

{ #category : 'initialization' }
DockProjectView >> initializePresenters [
	self addStyle: 'dockProjectView'.

	toolbarPresenter := self instantiate: DockToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #project).	
	toolbarPresenter addPresenter: (self newMenuButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'menu');
		actions: (self actions actionsForAll: #(new extra));
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

{ #category : 'initialization' }
DockProjectView >> registerToSystemEvents [

	self announcer
		when: PackageAdded send: #eventPackageAdded: to: self;"
		when: PackageRenamed send: #eventPackageRenamed: to: self;
		when: PackageRemoved send: #eventPackageRemoved: to: self;
		when: PackageTagAdded send: #eventPackageTagAdded: to: self;
		when: PackageTagRemoved send: #eventPackageTagRemoved: to: self;
		when: PackageTagRenamed send: #eventPackageTagRenamed: to: self;"
		when: ClassAdded send: #eventBehaviorAdded: to: self;
		when: ClassRemoved send: #eventBehaviorRemoved: to: self";
		when: MethodAdded send: #eventMethodAdded: to: self;
		when: MethodRemoved send: #eventMethodRemoved: to: self;
		when: ProtocolAdded send: #eventProtocolAdded: to: self;
		when: ProtocolRemoved send: #eventProtocolRemoved: to: self;
		when: ClassModifiedClassDefinition send: #eventBehaviorModified: to: self;
		when: MethodModified send: #eventMethodModified: to: self;
		when: ClassRepackaged send: #eventClassRepackaged: to: self;
		when: ClassRenamed send: #eventClassRenamed: to: self;
		when: ClassCommented send: #eventClassCommented: to: self;
		when: MethodRecategorized send: #eventMethodRecategorized: to: self."
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
		listPresenter roots: self model allChildren.
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
