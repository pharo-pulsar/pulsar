Class {
	#name : 'PvProjectView',
	#superclass : 'PvPerspectiveView',
	#instVars : [
		'projectTreePresenter'
	],
	#category : 'Perspective-Project-View',
	#package : 'Perspective-Project',
	#tag : 'View'
}

{ #category : 'accessing' }
PvProjectView class >> defaultContainerName [

	^ #overview
]

{ #category : 'accessing' }
PvProjectView class >> defaultTitle [

	^ 'Project'
]

{ #category : 'accessing - actions' }
PvProjectView class >> defineActionGroupAction: actionGroup [
	<perspectiveActionGroup: #action>
	
	actionGroup 
		name: 'Action';
		priority: 30;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
PvProjectView class >> defineActionGroupNew: actionGroup [
	<perspectiveActionGroup: #actionNew>
	
	actionGroup 
		name: 'New';
		priority: 20;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
PvProjectView class >> defineActionGroupProject: actionGroup [
	<perspectiveActionGroup: #project>
	
	actionGroup 
		name: 'Project';
		priority: 10;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
PvProjectView class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #project with: { 
			$n	mod1 	->	PvNewProjectCommand new.
			$o mod1  -> PvOpenProjectCommand new.
							PvRefreshProjectCommand new.
		};
		registerGroup: #actionNew with: { 
			PvNewPackageCommand new.
			PvNewPackageTagCommand new.
			PvNewClassCommand new.
			PvNewTraitCommand new
		};
		registerGroup: #action with: { 
			$r mod1 -> PvRenamePackageCommand new.
			$x mod1 -> PvRemovePackageCommand new.
		}
]

{ #category : 'as yet unclassified' }
PvProjectView >> activateProject: aBaselineClass [

	self model: (PvProjectModel 
		newEnvironment: self perspective model
		entity: aBaselineClass).
	projectTreePresenter takeKeyboardFocus
]

{ #category : 'initialization' }
PvProjectView >> connectPresenters [

	projectTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self selectWith: aSelection ].
	projectTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self activateWith: aSelection ]
]

{ #category : 'initialization' }
PvProjectView >> contextMenuActionGroups [

	^ #(project actionNew action)
]

{ #category : 'layout' }
PvProjectView >> defaultLayout [

	^ self layout: (SpBoxLayout newTopToBottom
		add: projectTreePresenter;
		yourself)
]

{ #category : 'private - events' }
PvProjectView >> entitySelected: aModel [
	| classModel |

	aModel includesClassModel ifFalse:[ ^ self ]. 
	classModel := aModel asClassModel.
	projectTreePresenter selectedItem = classModel ifTrue: [ ^ self ].
	projectTreePresenter selectItem: classModel
]

{ #category : 'initialization' }
PvProjectView >> initializePresenters [

	self addStyle: 'pvProjectView'.

	projectTreePresenter := self newEntityTree
		addStyle: 'pvProjectTree';
		actions: self contextMenuActions;
		yourself
]

{ #category : 'initialization' }
PvProjectView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter toolbar: self toolbar
]

{ #category : 'selecting' }
PvProjectView >> selectClass: aClass [
	| classModel |

	classModel := PvClassModel 
		newEnvironment: self model environmentModel 
		entity: aClass.
		
	projectTreePresenter selectItem: classModel
]

{ #category : 'accessing' }
PvProjectView >> selectedEntitiesInPath [

	^ projectTreePresenter selection selectedItemsInPath

]

{ #category : 'spotter' }
PvProjectView >> spotterDependencesClassesFor: aStep [
	<spotterOrder: 100 context: #environment>

	aStep addProcessor: ((PvClassProcessor newEnvironment: self model dependencesEnvironment)
		label: 'Dependences';
		yourself)
]

{ #category : 'spotter' }
PvProjectView >> spotterDependencesImplementorsFor: aStep [
	<spotterOrder: 110 context: #environment>

	aStep addProcessor: ((PvImplementorsProcessor newEnvironment: self model dependencesEnvironment)
		label: 'Dependences';
		yourself)
]

{ #category : 'spotter' }
PvProjectView >> spotterProjectClassesFor: aStep [
	<spotterOrder: 10 context: #environment>

	aStep addProcessor: ((PvUnifiedProcessor newEnvironment: self model projectEnvironment)
		label: 'Project';
		wantsToDisplayOnEmptyQuery: true;
		yourself)
]

{ #category : 'spotter' }
PvProjectView >> spotterProjectImplementorsFor: aStep [
	"<spotterOrder: 20 context: #environment>"

	aStep addProcessor: ((PvImplementorsProcessor newEnvironment: self model projectEnvironment)
		label: 'Project';
		yourself)
]

{ #category : 'spotter' }
PvProjectView >> spotterSystemClassesFor: aStep [
	<spotterOrder: 200 context: #environment>

	aStep addProcessor: ((PvClassProcessor newEnvironment: self model systemEnvironment)
		label: 'System';
		yourself)
]

{ #category : 'spotter' }
PvProjectView >> spotterSystemImplementorsFor: aStep [
	<spotterOrder: 210 context: #environment>

	aStep addProcessor: ((PvImplementorsProcessor newEnvironment: self model systemEnvironment)
		label: 'System';
		yourself)
]

{ #category : 'initialization' }
PvProjectView >> toolbar [

	^ (self instantiate: PvHeaderBarPresenter)
		toolbarActions: (self actions actionsForAll: #(project));
		yourself
]

{ #category : 'initialization' }
PvProjectView >> updatePresenter [

	self model ifNil: [ ^ self ].
	projectTreePresenter 
		roots: { self model };
		expandRoots.
	"self withTileWindowDo: [ :w | 
		w windowIcon: (self model windowIconComposite buildOn: self application).
		w title: self title ]"
]
