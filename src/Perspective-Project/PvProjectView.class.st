Class {
	#name : #PvProjectView,
	#superclass : #PvContainedPresenter,
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
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	projectTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ]
]

{ #category : #actions }
PvProjectView >> doNewClass [
	| items parentModel |

	items := projectTreePresenter selection selectedItemsInPath.
	items ifEmpty: [ self error: 'TODO' ].

	parentModel := items reversed detect: [ :each | each isPackageOrTag ].
		
	self announceActivated: (PvNewClassModel
		newEnvironment: self model environmentModel
		entity: (PvNewClass newParent: parentModel entity))

	"newClass := (PvClassCreationDialog 
			newApplication: self application 
			model: packageModel) 
		openModalWithParent: self window.
	newClass ifNil: [ ^ self ]."

]

{ #category : #initialization }
PvProjectView >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (projectTreePresenter := self newEntityTree);
		yourself).

	projectTreePresenter addStyle: 'stProjectTree'
]

{ #category : #initialization }
PvProjectView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter toolbar: self toolbar
]

{ #category : #initialization }
PvProjectView >> toolbar [

	^ self newToolbar
		addStyle: 'stSmallToolbar';
		beIcons;
		add: (self newToolbarButton
			icon: ((PvCompositeIcon newName: #class) addNew; buildOn: self);
			label: 'Add class';
			action: [ self doNewClass ];
			yourself);
		add: (self newToolbarButton
			icon: ((PvCompositeIcon newName: #trait) addNew; buildOn: self);
			label: 'Add trait';
			action: [  ];
			yourself);
		yourself
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
