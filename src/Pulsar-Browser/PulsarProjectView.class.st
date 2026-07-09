"
A view of the system based on `projects` (which for now are organised in baselines). 
The view alloes the navigation (and model interaction) trough projects, packages and classes.

Conceptually, this is the entry-point of the browser user to explore the system.
"
Class {
	#name : 'PulsarProjectView',
	#superclass : 'PulsarBaseProjectView',
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
			actionEnabled: [ 
				self hasSelectedEntity 
					and: [ (self model findRootForEntity: self selectedEntity) isProject ] ];
			action: [ self refreshProject ] ] ]
]

{ #category : 'private - actions' }
PulsarProjectView >> doCloseProject: aProjectModel [

	self removeProjectModel: aProjectModel
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
	| projectName project |
	
	projectName := self application newRequest
		title: 'New project';
		message: 'Project name';
		openModalWithParent: self window.
	projectName ifNil: [ ^ self ].

	project := self model ensureVolatileProjectNamed: projectName.
	self updatePresenter.
	listPresenter 
		selectPathByItems: { project } 
		scrollToSelection: true
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

{ #category : 'events - system' }
PulsarProjectView >> eventMethodModified: anAnnouncement [
	"why this is still here?"
]

{ #category : 'events - system' }
PulsarProjectView >> eventPackageAdded: anAnnouncement [

	logger trace: anAnnouncement package
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

{ #category : 'accessing' }
PulsarProjectView >> openedProjects [

	^ self model children
]

{ #category : 'private' }
PulsarProjectView >> panelPlacedIconName [

	^ 'projects'
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

{ #category : 'private - actions' }
PulsarProjectView >> removeProjectModel: aProjectModel [

	self model removeProjectModel: aProjectModel.
	self updatePresenter.
	self withWindowDo: [ :aWindow | aWindow updateTitle ]
]

{ #category : 'accessing - snapshot' }
PulsarProjectView >> snapshot [

	^ PulsarProjectSnapshot on: self
]

{ #category : 'initialization' }
PulsarProjectView >> sortProjects: aCollection [

	^ aCollection sorted: [ :each | each isProject and: [ each isVolatileProject ] ] descending
]

{ #category : 'initialization' }
PulsarProjectView >> updateListPresenterExpanding: aPath [
	
	mutex critical: [
		listPresenter roots: (self sortProjects: self model allChildren).
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
