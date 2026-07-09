"
A project view scoped to a single project (PulsarBaselineProjectModel). Unlike PulsarProjectView which shows all open projects as roots, this view presents the packages of a single project as tree roots.

It provides tree navigation through packages, tags, and classes, with filtering, creation actions, and event-driven tree updates for class additions, removals, and renames.
"
Class {
	#name : 'PulsarSingleProjectView',
	#superclass : 'PulsarBaseProjectView',
	#traits : 'PulsarTEditor',
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'actions-definition' }
PulsarSingleProjectView >> defineProjectActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #project with: [ :group | group
		priority: 100;
		name: 'Project';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			priority: 110;
			name: 'Refresh project';
			description: 'Refresh this project (reload configuration)';
			iconName: 'refresh';
			action: [ self refreshProject ] ];
		addActionWith: [ :action | action
			priority: 120;
			name: 'Test Runner';
			description: 'Open a Test Runner on this Project';
			iconName: 'testRunner';
			action: [
				self scheduleTask: [ 
					(PulsarTestRunnerBrowser 
						newApplication: self application 
						model: self model newTestRunnerModel) 
						open ] ] ] ]
]

{ #category : 'actions' }
PulsarSingleProjectView >> doNewPackage [
	| packageName package |
	
	packageName := self application newRequest
		title: 'New package';
		message: 'Package name';
		openModalWithParent: self window.
	packageName ifNil: [ ^ self ].

	package := self model addPackageNamed: packageName.
	self updatePresenter.
	listPresenter selectPathByItems: { package } scrollToSelection: true
]

{ #category : 'actions' }
PulsarSingleProjectView >> doNewPackageTag [
	| packageName parents package packageTag |
	
	packageName := self application newRequest
		title: 'New tag';
		label: 'Tag name';
		openModalWithParent: self window.
	packageName ifNil: [ ^ self ].

	parents := self closestPathInPathMatching: [ :each | each isPackage ].
	parents ifNil: [ ^ self ].

	package := parents first.

	packageTag := package addPackageTagNamed: packageName.
	self updatePresenter.
	listPresenter
		selectPathByItems: {
				package.
				packageTag }
		scrollToSelection: true
]

{ #category : 'initialization' }
PulsarSingleProjectView >> initializePresenters [

	self addStyle: 'pulsarSingleProjectView'.

	toolbarPresenter := self instantiate: PulsarToolbarPresenter.
	toolbarPresenter actions: (self actions actionsFor: #project).
	toolbarPresenter addPresenter: (self newMenuButton
		addStyle: 'flat';
		icon: (self iconNamed: 'menu');
		actions: (self actions actionsForAll: #( new extra ));
		yourself).

	self intializeProjectTree.
	self initializeFilter
]

{ #category : 'initialization' }
PulsarSingleProjectView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Project - ' , self model name
]

{ #category : 'accessing' }
PulsarSingleProjectView >> panelPlacedIconName [

	^ 'project'
]

{ #category : 'actions' }
PulsarSingleProjectView >> refreshProject [

	self updatePresenter
]

{ #category : 'events' }
PulsarSingleProjectView >> refreshProjectPath: aPath [
	| pathToPackage |
	
	aPath ifNil: [ ^ self ].

	pathToPackage := aPath first: (aPath size min: 1).
	(listPresenter isExpanded: pathToPackage) ifTrue: [
		self application defer: [
			mutex critical: [
				listPresenter
					collapsePath: pathToPackage;
					expandPath: aPath ] ] ]
]

{ #category : 'snapshot' }
PulsarSingleProjectView >> snapshot [

	^ PulsarPanelSnapshot on: self
]

{ #category : 'updating' }
PulsarSingleProjectView >> updateListPresenterExpanding: aPath [

	mutex critical: [
		listPresenter roots: self model children.
		aPath ifNotNil: [ 
			listPresenter expandPath: aPath ] ]
]

{ #category : 'initialization' }
PulsarSingleProjectView >> updatePresenter [

	self model ifNil: [
		listPresenter roots: #().
		^ self ].

	self updateListPresenterExpanding: nil
]
