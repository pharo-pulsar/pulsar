"
A view of the system based on `projects` (which for now are organised in baselines). 
The view alloes the navigation (and model interaction) trough projects, packages and classes.

Conceptually, this is the entry-point of the browser user to explore the system.
"
Class {
	#name : 'PulsarProjectView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter',
		'mutex',
		'filterInputPresenter',
		'filterListPresenter'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'defaults' }
PulsarProjectView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 1;
		yourself
]

{ #category : 'private' }
PulsarProjectView >> activateContextPopover [

]

{ #category : 'actions' }
PulsarProjectView >> addProject: aBaselineClass [
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
PulsarProjectView >> canRemoveSelectedEntity [

	^ self selectedEntity
		ifNotNil: [ :anEntityModel | anEntityModel canBeRemoved ]
		ifNil: [ false ]
]

{ #category : 'testing' }
PulsarProjectView >> canRenameSelectedEntity [

	^ self selectedEntity
		ifNotNil: [ :anEntityModel | anEntityModel canBeRenamed ]
		ifNil: [ false ]
]

{ #category : 'private' }
PulsarProjectView >> closestEntityInPathMatching: aBlock [

	^ self selectedEntitiesInPath
		ifNotEmpty: [ :entities | entities reversed detect: aBlock ] 
		ifEmpty: [ nil ]
]

{ #category : 'private' }
PulsarProjectView >> closestPathInPathMatching: aBlock [
	| selectedEntities  |

	selectedEntities := self selectedEntitiesInPath.
	selectedEntities ifNil: [ ^ nil ].
	
	selectedEntities withIndexDo: [ :each : index | 
		(aBlock value: each)
			ifTrue: [ ^ selectedEntities copyFrom: 1 to: index ] ].

	^ nil
]

{ #category : 'initialization' }
PulsarProjectView >> connectPresenters [

	super connectPresenters.
	
	filterListPresenter outputSelectionPort 
		transmitDo: [ :anEntity | self entitySelected: anEntity ].
	filterListPresenter outputActivationPort 
		transmitDo: [ :anEntity | self entityActivated: anEntity ].	
	filterInputPresenter whenTextChangedDo: [ :aString | 
		self updateFilterWith: aString ]
]

{ #category : 'private' }
PulsarProjectView >> deactivateContextPopover [

	
]

{ #category : 'layout' }
PulsarProjectView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		add: filterListPresenter;
		add: filterInputPresenter expand: false;
		yourself
]

{ #category : 'private - definitions' }
PulsarProjectView >> defineExtraActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: 'extra' with: [ :group | group 
		priority: 900;
		name: 'Extra';
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Collapse All';
			description: 'Collapses all open projects';
			iconName: 'collapse-all';
			action: [ self doCollapseAll ] ] ]
]

{ #category : 'private - definitions' }
PulsarProjectView >> defineNewActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #new with: [ :group | group
		priority: 200;
		name: 'New';
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			priority: 210;
			name: 'New package';
			description: 'Add a new package to the environment';
			iconName: 'new-file';
			action: [ self doNewPackage ] ];
		addActionWith: [ :action | action
			priority: 220;
			name: 'New tag';
			description: 'Add a new tag to this package';
			iconName: 'new-file';
			action: [ self doNewPackageTag ] ];
		addActionWith: [ :action | action
			priority: 230;
			name: 'New class';
			description: 'Add a new class to the environment';
			iconName: 'new-file';
			action: [ self doRequestNewClass ] ];
		addActionWith: [ :action | action
			priority: 240;
			name: 'New trait';
			description: 'Add a new trait to the environment';
			iconName: 'new-file';
			action: [ self doRequestNewTrait ] ] ]
]

{ #category : 'private - definitions' }
PulsarProjectView >> defineProjectActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #project with: [ :group | group 
		priority: 100;
		name: 'Project';
		beDisplayedAsSubMenu;	
		addActionWith: [ :action | action 
			priority: 110;
			name: 'New project';
			description: 'Create a new project (baseline)';
			iconName: 'add';
			shortcutKey: $n mod1;
			action: [ self doNewProject ] ];
		addActionWith: [ :action | action 
			priority: 120;
			name: 'Open project';
			description: 'Open project';
			iconName: #openProject;
			shortcutKey: $o mod1;
			action: [ self doOpenProject ] ];
		addActionWith: [ :action | action 
			priority: 130;
			name: 'Refresh project';
			description: 'Refresh this project (reload configuration)';
			iconName: 'refresh';
			action: [ self refreshProject ] ] ]
]

{ #category : 'private - actions' }
PulsarProjectView >> doCloseProject: aProjectModel [

	self removeProjectModel: aProjectModel
]

{ #category : 'private - actions' }
PulsarProjectView >> doCollapseAll [

	listPresenter 
		unselectAll;
		collapseAll
]

{ #category : 'private - actions' }
PulsarProjectView >> doNewPackage [

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
PulsarProjectView >> doNewPackageTag [
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
PulsarProjectView >> doNewProject [
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
PulsarProjectView >> doOpenProject [
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

{ #category : 'private - refactors' }
PulsarProjectView >> doRemoveClass [
	| parentPath |

	"take parent path"
	parentPath := listPresenter selection selectedPath allButLast.
	self application schedule: [
		"run refactor"
		(ReRemoveClassDriver newApplication: self application) 
			classes: { self selectedEntity };
			model: RBBrowserEnvironment new;
			scopes: { RBBrowserEnvironment new };
			runRefactoring.
		"select parent because if refactor went right, the selection was lost"	
		listPresenter
			selectPath: parentPath
			scrollToSelection: true ]
]

{ #category : 'private - actions' }
PulsarProjectView >> doRemoveSelectedEntity [
	"this can be anything on the tree: 
		- project (should I remove from image or just from dock?)
		- package (should I remove from image or just from project?)
		- tag (this one is easy)" 

	listPresenter selectedItem ifNotNil: [ :aModel |
		(PulsarProjectRemoveModel on: self) visit: aModel realModel ] 
]

{ #category : 'private - refactors' }
PulsarProjectView >> doRenameClass [
	| parentPath |

	"take parent path"
	parentPath := listPresenter selection selectedPath allButLast.
	self application schedule: [
		"run refactor"
		(ReRenameClassDriver newApplication: self owner application) 
			oldName: self selectedEntityName asSymbol;
			model: RBBrowserEnvironment new;
			scopes: { RBBrowserEnvironment new };
			runRefactoring.
		"select parent because if refactor went right, the selection was lost"	
		listPresenter
			selectPath: parentPath
			scrollToSelection: true ]
]

{ #category : 'private - actions' }
PulsarProjectView >> doRenameSelectedEntity [
	listPresenter selectedItem ifNotNil: [ :aModel |
		(PulsarProjectRenameModel on: self) visit: aModel realModel ] 
]

{ #category : 'private - actions' }
PulsarProjectView >> doRequestNewClass [
	| parent |

	parent := self closestEntityInPathMatching: [ :each | each isPackageOrTag ].
	parent ifNil: [ ^ self ].
	
	self notifyActivateEntity: (PvClassModel
		newEnvironment: self model environmentModel 
		beNewClassWithParent: parent)
]

{ #category : 'private - actions' }
PulsarProjectView >> doRequestNewTrait [

	| parent |

	parent := self closestEntityInPathMatching: [ :each | each isPackageOrTag ].
	parent ifNil: [ ^ self ].
	
	self notifyActivateEntity: (PvClassModel
		newEnvironment: self model environmentModel 
		beNewTraitWithParent: parent)	
]

{ #category : 'events - system' }
PulsarProjectView >> eventBehaviorAdded: anAnnouncement [
	| classAdded path |
	
	classAdded := anAnnouncement classAdded.
	logger trace: classAdded.
	
	path := self model findPathForClass: classAdded.
	path ifNotNil: [
		self refreshProjectPath: path ]
]

{ #category : 'events - system' }
PulsarProjectView >> eventBehaviorRemoved: anAnnouncement [
	| classRemoved path |
	
	classRemoved := anAnnouncement classRemoved.
	logger trace: classRemoved.
	
	path := self model findPathForPackage: classRemoved package.
	self refreshProjectPath: path
]

{ #category : 'events - system' }
PulsarProjectView >> eventBehaviorRenamed: anAnnouncement [
	| classRenamed path |
	
	classRenamed := anAnnouncement classRenamed.
	logger trace: classRenamed.
	
	path := self model findPathForClass: classRenamed.
	path ifNotNil: [
		self refreshProjectPath: path ]
]

{ #category : 'events' }
PulsarProjectView >> eventEditorActivated: anAnnouncement [
	| editorModel classModel path |
	
	editorModel := anAnnouncement value model.
	editorModel includesClassModel ifFalse: [ ^ self ].
	
	classModel := editorModel asClassModel.
	(listPresenter selectedItem isNotNil and: [ listPresenter selectedItem realModel = classModel ]) 
		ifTrue: [ ^ self ].
 
	path := self model findPathForClassModel: classModel. 
	path ifNil: [ ^ self ].
	
	mutex critical: [
		listPresenter selectPath: path ]
]

{ #category : 'events - system' }
PulsarProjectView >> eventMethodModified: anAnnouncement [
	"why this is still here?"
]

{ #category : 'events - system' }
PulsarProjectView >> eventPackageAdded: anAnnouncement [

	logger trace: anAnnouncement package
]

{ #category : 'private' }
PulsarProjectView >> filterStartingSize [

	^ 3
]

{ #category : 'testing' }
PulsarProjectView >> hasSelectedClass [

	^ self selectedEntity
		ifNotNil: [ :anEntityModel | anEntityModel realModel isClassModel ]
		ifNil: [ false ]
]

{ #category : 'testing' }
PulsarProjectView >> hasSelectedEntity [

	^ self selectedEntity isNotNil
]

{ #category : 'initialization' }
PulsarProjectView >> initialize [

	mutex := Mutex new.
	super initialize
]

{ #category : 'initialization' }
PulsarProjectView >> initializeFilter [

	filterListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'pulsarProjectFilterList';
		display: [ :aModel | aModel name ];
		rowPresenterClass: PulsarProjectNodeRow;
		actions: (SpActionGroup new
			add: self actions;
			addDynamicGroup: #dynamic with: [ :group | group add: self refactorActions ];
			addShortcutWith: [ :action | action 
				shortcutKey: KeyboardKey right asKeyCombination; 
				action: [ self activateContextPopover ] ];	
			addShortcutWith: [ :action | action 
				shortcutKey: KeyboardKey left asKeyCombination | KeyboardKey escape asKeyCombination; 
				action: [ self deactivateContextPopover ] ];	
			yourself);
		yourself.

	"starts hidden"	
	filterListPresenter hide.
	
	filterInputPresenter := self newTextInput
		addStyle: 'flat';
		placeholder: ('Filter ({1}+ characters)...' format: { self filterStartingSize });
		yourself
]

{ #category : 'initialization' }
PulsarProjectView >> initializePresenters [

	self addStyle: 'pulsarProjectView'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #project).	
	toolbarPresenter addPresenter: (self newMenuButton 
		addStyle: 'flat';
		icon: (self iconNamed: 'menu');
		actions: (self actions actionsForAll: #(new extra));
		yourself).

	self intializeProjectTree.
	self initializeFilter
]

{ #category : 'initialization' }
PulsarProjectView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Project'
]

{ #category : 'initialization' }
PulsarProjectView >> intializeProjectTree [

	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		addStyle: 'pulsarProjectTree';
		children: [ :aModel | aModel children ];
		rowPresenterClass: PulsarProjectNodeRow;
		searchMatching: [ :anEntity :pattern | anEntity matches: pattern ];
		actions: (SpActionGroup new
			add: self actions;
			addDynamicGroup: #dynamic with: [ :group | group add: self refactorActions ];
			addShortcutWith: [ :action | action 
				shortcutKey: KeyboardKey right asKeyCombination; 
				action: [ self activateContextPopover ] ];	
			addShortcutWith: [ :action | action 
				shortcutKey: KeyboardKey left asKeyCombination | KeyboardKey escape asKeyCombination; 
				action: [ self deactivateContextPopover ] ];	
			yourself);
		yourself.

]

{ #category : 'private - actions' }
PulsarProjectView >> maybeOpenFlyView [

	self halt
]

{ #category : 'private - announcing' }
PulsarProjectView >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	super notifyActivateEntity: anEntity realModel
]

{ #category : 'private - announcing' }
PulsarProjectView >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity realModel newSelectionAnnouncement
]

{ #category : 'accessing' }
PulsarProjectView >> openedProjects [

	^ self model children
]

{ #category : 'initialization' }
PulsarProjectView >> refactorActions [

	self hasSelectedEntity ifFalse: [ ^ SpActionGroup new ].

	^ self selectedEntity realModel actionsWithContextOn: self
]

{ #category : 'private' }
PulsarProjectView >> refreshProjectPath: path [
	"this is a hack to force recalculation of package view. Maybe it would 
	 be worthy to revisit this in the future"
	| pathToPackage |
	
	self flag: #TODO. "Maybe revisit?"
	
	"under certain conditions (e.g. no project :P), path can be nil"
	path ifNil: [ ^ self ].
	
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
PulsarProjectView >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarEditorActivated 
		send: #eventEditorActivated: 
		to: self	
]

{ #category : 'initialization' }
PulsarProjectView >> registerToSystemEvents [

	self announcer
		when: PackageAdded 					send: #eventPackageAdded: 		to: self;"
		when: PackageRenamed 				send: #eventPackageRenamed: 		to: self;
		when: PackageRemoved 				send: #eventPackageRemoved: 		to: self;
		when: PackageTagAdded 				send: #eventPackageTagAdded: 	to: self;
		when: PackageTagRemoved 				send: #eventPackageTagRemoved: 	to: self;
		when: PackageTagRenamed 				send: #eventPackageTagRenamed: 	to: self;"
		when: ClassAdded 					send: #eventBehaviorAdded: 		to: self;
		when: ClassRemoved 					send: #eventBehaviorRemoved: 	to: self;
		when: ClassRenamed 					send: #eventBehaviorRenamed: 	to: self";
		when: MethodAdded 					send: #eventMethodAdded: 		to: self;
		when: MethodRemoved 					send: #eventMethodRemoved: 		to: self;
		when: ProtocolAdded 					send: #eventProtocolAdded: 		to: self;
		when: ProtocolRemoved 				send: #eventProtocolRemoved: 	to: self;
		when: ClassModifiedClassDefinition 	send: #eventBehaviorModified: 	to: self;
		when: MethodModified 				send: #eventMethodModified: 		to: self;
		when: ClassRepackaged 				send: #eventClassRepackaged: 	to: self;
		when: ClassRenamed 					send: #eventClassRenamed: 		to: self;
		when: ClassCommented 				send: #eventClassCommented: 		to: self;
		when: MethodRecategorized 			send: #eventMethodRecategorized:	to: self."
]

{ #category : 'private - actions' }
PulsarProjectView >> removeProjectModel: aProjectModel [

	self model removeProjectModel: aProjectModel.
	self updatePresenter.
	self withWindowDo: [ :aWindow | aWindow updateTitle ]
]

{ #category : 'private' }
PulsarProjectView >> selectedEntitiesInPath [

	^ listPresenter selection selectedItemsInPath

]

{ #category : 'accessing' }
PulsarProjectView >> selectedEntity [

	^ self listPresenter selectedItem
]

{ #category : 'accessing' }
PulsarProjectView >> selectedEntityName [

	^ self selectedEntity
		ifNotNil: [ :anEntityModel | anEntityModel name ]
		ifNil: [ 'None' ]
]

{ #category : 'accessing - snapshot' }
PulsarProjectView >> snapshot [

	^ PulsarProjectSnapshot on: self
]

{ #category : 'private' }
PulsarProjectView >> toolbarPresenter [

	^ toolbarPresenter
]

{ #category : 'private' }
PulsarProjectView >> updateFilterWith: aString [

	"just match after 3 for speed reasons"
	(aString isEmptyOrNil or: [ aString size < self filterStartingSize ]) ifTrue: [ 
		self application defer: [
			listPresenter show.
			filterListPresenter hide ].
		^ self ].
			
	self scheduleTask: [
		| items |
		items := self model filterWith: aString.
		self application defer: [
			listPresenter hide.
			filterListPresenter show.
			filterListPresenter items: items ] ]
]

{ #category : 'initialization' }
PulsarProjectView >> updateListPresenterExpanding: aPath [
	
	mutex critical: [
		listPresenter roots: self model allChildren.
		aPath ifNotNil: [
			listPresenter expandPath: aPath ] ]
]

{ #category : 'initialization' }
PulsarProjectView >> updatePresenter [

	self model ifNil: [ 
		listPresenter roots: #().
		^ self ].
	
	self updateListPresenterExpanding: #(1)
]
