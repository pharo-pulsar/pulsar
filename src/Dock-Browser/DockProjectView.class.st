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
DockProjectView class >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder 
		addGroup: #project with: [ :group | group 
			priority: 100;
			name: 'Project';
			beDisplayedAsSubMenu;	
			addActionWith: [ :action | action 
				priority: 110;
				name: 'New project';
				description: 'Create a new project (baseline)';
				iconName: 'new-folder';
				shortcutKey: $n mod1;
				action: [ :aContext | aContext doNewProject ] ];
			addActionWith: [ :action | action 
				priority: 120;
				name: 'Open project';
				description: 'Open project';
				iconName: #openProject;
				shortcutKey: $o mod1;
				action: [ :aContext | aContext doOpenProject ] ];
			addActionWith: [ :action | action 
				priority: 130;
				name: 'Refresh project';
				description: 'Refresh this project (reload configuration)';
				iconName: 'refresh';
				action: [ :aContext | aContext refreshProject ] ] ];
		addGroup: #new with: [ :group | group
			priority: 200;
			name: 'New';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				priority: 210;
				name: 'New package';
				description: 'Add a new package to the environment';
				iconName: 'new-file';
				action: [ :aContext | aContext doNewPackage ] ];
			addActionWith: [ :action | action
				priority: 220;
				name: 'New tag';
				description: 'Add a new tag to this package';
				iconName: 'new-file';
				action: [ :aContext | aContext doNewPackageTag ] ];
			addActionWith: [ :action | action
				priority: 230;
				name: 'New class';
				description: 'Add a new class to the environment';
				iconName: 'new-file';
				action: [ :aContext | aContext doRequestNewClass ] ];
			addActionWith: [ :action | action
				priority: 240;
				name: 'New trait';
				description: 'Add a new trait to the environment';
				iconName: 'new-file';
				action: [ :aContext | aContext doRequestNewTrait ] ] ];
		addGroup: #action with: [ :group | group 
			priority: 300;
			name: 'Action';
			beDisplayedAsGroup	;
			addActionWith: [ :action | action
				priority: 310;
				dynamicName: [ :aContext | 'Rename ', aContext selectedEntityName ];
				description: 'Rename package or tag (and all its contexts)';
				shortcutKey: $r mod1;
				actionEnabled: [ :aContext | aContext canRenameSelectedEntity ];
				action: [ :aContext | aContext doRenameSelectedEntity ] ];
			addActionWith: [ :action | action 
				priority: 320;
				dynamicName: [ :aContext |
					String streamContents: [ :stream | 
						stream << 'Remove '.
						stream << aContext selectedEntityName.
						aContext selectedEntity isProject
							ifTrue: [ stream << ' from project list' ] ] ];
				description: 'Remove from project';
				iconName: 'trash';
				shortcutKey: $x mod1;
				actionEnabled: [ :aContext | aContext canRemoveSelectedEntity ];
				action: [ :aContext | aContext doRemoveSelectedEntity ] ] ];
		addGroup: #extra with: [ :group | group 
			priority: 900;
			name: 'Extra';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'Collapse All';
				description: 'Collapses all open projects';
				iconName: 'collapse-all';
				action: [ :aContext | aContext doCollapseAll ] ] ]
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

{ #category : 'testing' }
DockProjectView >> canRemoveSelectedEntity [

	^ self selectedEntity
		ifNotNil: [ :anEntityModel | anEntityModel canBeRemoved ]
		ifNil: [ false ]
]

{ #category : 'testing' }
DockProjectView >> canRenameSelectedEntity [

	^ self selectedEntity
		ifNotNil: [ :anEntityModel | anEntityModel canBeRenamed ]
		ifNil: [ false ]
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
DockProjectView >> doNewPackage [

	| packageName project package |
	packageName := self application newRequest
		               title: 'New package';
		               message: 'Package name';
		               openModalWithParent: self window.
	packageName ifNil: [ ^ self ].

	project := self closestEntityInPathMatching: [ :each | each isProject ].
	project ifNil: [ ^ self ].

	package := project addPackageNamed: packageName.
	self updatePresenter.
	listPresenter
		selectPathByItems: {
				project.
				package }
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
		
	self application newInform
		title: 'Work in progress';
		message: 'Not implemented yet. You can create a baseline for it :)';
		openModalWithParent: self window.
	true ifTrue: [ ^ self ].
	
	projectName := self application newRequest
       title: 'New project';
       message: 'Project name';
       openModalWithParent: self window.
	projectName ifNil: [ ^ self ].

	project := self model newProjectNamed: projectName.
	self addProject: project.
	self notifyActivateEntity: (self listPresenter roots detect: [ :each | each entity = project ])
]

{ #category : 'private - actions' }
DockProjectView >> doOpenProject [
	| result |

	result := self application newSelect
		extent: 300@500;
		title: 'Open project';
		message: 'Select project';
		items: self model allBaselines;
		display: [ :aClass | aClass name allButFirst: 10 "'BaselineOf' size " ];
		displayIcon: [ :aClass | self application iconNamed: 'project' ];
		openModalWithParent: self window.

	result ifNil: [ ^ self ].
	self addProject: result
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
	
	classAdded := anAnnouncement classAdded.
	logger trace: classAdded.
	
	path := self model findPathForClass: classAdded.
	self refreshProjectPath: path
]

{ #category : 'events - system' }
DockProjectView >> eventBehaviorRemoved: anAnnouncement [
	| classRemoved path |
	
	classRemoved := anAnnouncement classRemoved.
	logger trace: classRemoved.
	
	path := self model findPathForPackage: classRemoved package.
	self refreshProjectPath: path
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

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'dockProjectTree';
		children: [ :aModel | aModel children ];
		rowPresenterClass: DockProjectNodeRow;
		searchMatching: [ :anEntity :pattern | anEntity matches: pattern ];
		yourself.
	
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

{ #category : 'private' }
DockProjectView >> refreshProjectPath: path [
	"this is a hack to force recalculation of package view. Maybe it would 
	 be worthy to revisit this in the future"
	| pathToPackage |
	
	self flag: #TODO. "Maybe revisit?"
	
	logger trace: path.
	logger trace: (listPresenter isExpanded: path).
	
	pathToPackage := path first: 2.
	(listPresenter isExpanded: pathToPackage) ifTrue: [
		self application defer: [
			mutex critical: [
				listPresenter 
					collapsePath: pathToPackage; 
					expandPath: path ] ] ]
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

{ #category : 'accessing' }
DockProjectView >> selectedEntity [

	^ self listPresenter selectedItem
]

{ #category : 'accessing' }
DockProjectView >> selectedEntityName [

	^ self selectedEntity
		ifNotNil: [ :anEntityModel | anEntityModel name ]
		ifNil: [ 'None' ]
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
