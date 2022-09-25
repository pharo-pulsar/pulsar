Class {
	#name : #PvProjectView,
	#superclass : #PvPerspectiveView,
	#instVars : [
		'projectTreePresenter'
	],
	#category : #'Perspective-Project-View'
}

{ #category : #accessing }
PvProjectView class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvProjectView class >> defaultTitle [

	^ 'Project'
]

{ #category : #initialization }
PvProjectView >> connectPresenters [

	projectTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self selectWith: aSelection ].
	projectTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self activateWith: aSelection ]
]

{ #category : #initialization }
PvProjectView >> contextMenuActions [

	^ PvProjectCommand buildMenu: #(default project actionNew action) on: self
]

{ #category : #actions }
PvProjectView >> doOpenProject [
	
	self halt
		
]

{ #category : #'private - events' }
PvProjectView >> entitySelected: aModel [
	| classModel |

	aModel includesClassModel ifFalse:[ ^ self ]. 
	classModel := aModel asClassModel.
	projectTreePresenter selectedItem = classModel ifTrue: [ ^ self ].
	projectTreePresenter selectItem: classModel
]

{ #category : #initialization }
PvProjectView >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (projectTreePresenter := self newEntityTree);
		yourself).

	projectTreePresenter 
		addStyle: 'stProjectTree';
		contextMenu: [ self contextMenuActions asMenuPresenter ];
		contextKeyBindings: self contextMenuActions asKMCategory
]

{ #category : #initialization }
PvProjectView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter toolbar: self toolbar
]

{ #category : #selecting }
PvProjectView >> selectClass: aClass [
	| classModel |

	classModel := PvClassModel 
		newEnvironment: self model environmentModel 
		entity: aClass.
		
	projectTreePresenter selectItem: classModel
]

{ #category : #accessing }
PvProjectView >> selectedEntitiesInPath [

	^ projectTreePresenter selection selectedItemsInPath

]

{ #category : #spotter }
PvProjectView >> spotterDependencesClassesFor: aStep [
	<spotterOrder: 100 context: #environment>

	aStep addProcessor: ((PvClassProcessor newEnvironment: self model dependencesEnvironment)
		label: 'Dependences';
		yourself)
]

{ #category : #spotter }
PvProjectView >> spotterDependencesImplementorsFor: aStep [
	<spotterOrder: 110 context: #environment>

	aStep addProcessor: ((PvImplementorsProcessor newEnvironment: self model dependencesEnvironment)
		label: 'Dependences';
		yourself)
]

{ #category : #spotter }
PvProjectView >> spotterProjectClassesFor: aStep [
	<spotterOrder: 10 context: #environment>

	aStep addProcessor: ((PvUnifiedProcessor newEnvironment: self model projectEnvironment)
		label: 'Project';
		wantsToDisplayOnEmptyQuery: true;
		yourself)
]

{ #category : #spotter }
PvProjectView >> spotterProjectImplementorsFor: aStep [
	"<spotterOrder: 20 context: #environment>"

	aStep addProcessor: ((PvImplementorsProcessor newEnvironment: self model projectEnvironment)
		label: 'Project';
		yourself)
]

{ #category : #spotter }
PvProjectView >> spotterSystemClassesFor: aStep [
	<spotterOrder: 200 context: #environment>

	aStep addProcessor: ((PvClassProcessor newEnvironment: self model systemEnvironment)
		label: 'System';
		yourself)
]

{ #category : #spotter }
PvProjectView >> spotterSystemImplementorsFor: aStep [
	<spotterOrder: 210 context: #environment>

	aStep addProcessor: ((PvImplementorsProcessor newEnvironment: self model systemEnvironment)
		label: 'System';
		yourself)
]

{ #category : #initialization }
PvProjectView >> toolbar [

	^ self buildPerspectiveToolbarWith: [ :builder |
		builder 
			from: PvProjectCommand;
			mainGroup: #project;
			actionGroups: #action ]
]

{ #category : #initialization }
PvProjectView >> toolbarActions [

	^ PvProjectCommand buildToolbarOn: self
]

{ #category : #initialization }
PvProjectView >> updatePresenter [

	self model ifNil: [ ^ self ].
	projectTreePresenter 
		roots: { self model };
		expandRoots.
	"self withTileWindowDo: [ :w | 
		w windowIcon: (self model windowIconComposite buildOn: self application).
		w title: self title ]"
]
