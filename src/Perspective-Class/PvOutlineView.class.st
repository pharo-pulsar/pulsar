Class {
	#name : #PvOutlineView,
	#superclass : #PvContainedPresenter,
	#instVars : [
		'classTreePresenter',
		'outlineTreePresenter',
		'toolbar'
	],
	#category : #'Perspective-Class-View'
}

{ #category : #accessing }
PvOutlineView class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvOutlineView class >> defaultTitle [

	^ 'Outline'
]

{ #category : #'private - activating' }
PvOutlineView >> classActivated: aModel [

	self model: aModel newOutlineClassModel.
	self updatePresenter	
]

{ #category : #'private - selecting' }
PvOutlineView >> classSelected: aModel [
	| classModel |

	outlineTreePresenter selectedItem = aModel 
		ifTrue: [ ^ self ].

	classModel := aModel newOutlineClassModel.
	self model = classModel
		ifFalse: [ self model: classModel ].
	outlineTreePresenter selectItem: aModel
]

{ #category : #initialization }
PvOutlineView >> connectPresenters [

	outlineTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self announceSelectionChanged: aSelection ].
	outlineTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self announceActivated: aSelection ]
]

{ #category : #initialization }
PvOutlineView >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (outlineTreePresenter := self newTreeTable);
		yourself).

	outlineTreePresenter
		hideColumnHeaders;
		addStyle: 'stTree';
		addColumn: (SpCompositeTableColumn new 
			addColumn: ( SpImageTableColumn  new 
				evaluated: [ :aModel | aModel iconComposite buildOn: self application ];
				beNotExpandable;
				yourself);
			addColumn: ( SpStringTableColumn new 
				evaluated: [ :aModel | aModel name ];
				displayColor: [ :aModel | self colorNamed: aModel colorName ];
				yourself);
			"addColumn: ( SpStringTableColumn new 
				evaluated: [ :aModel | 'test' ];
				displayColor: [ :aModel | Color red ];
				displayAlignment: [ :aModel | SpColumnAlignment right ];
				yourself);"
			yourself);
		children: [ :aModel | aModel children ];
		addNavigationShortcuts.
		
	outlineTreePresenter addStyle: 'stProjectTree'
]

{ #category : #initialization }
PvOutlineView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter toolbar: self toolbar
]

{ #category : #'private - selecting' }
PvOutlineView >> methodSelected: aModel [
	| classModel |

	outlineTreePresenter selectedItem = aModel 
		ifTrue: [ ^ self ].

	classModel := aModel newOutlineClassModel.
	self model = classModel
		ifFalse: [ self model: classModel ].
	outlineTreePresenter selectItem: aModel
]

{ #category : #initialization }
PvOutlineView >> toolbar [

	^ (toolbar := self newToolbar) 
		addStyle: 'stSmallToolbar';
		beIcons;
		add: (self newToolbarButton
			icon: ((PvCompositeIcon newName: 'variable') addNew; addClass; buildOn: self);
			label: 'Add class variable';
			action: [  ];
			yourself);
		add: (self newToolbarButton
			icon: ((PvCompositeIcon newName: 'variable') addNew; buildOn: self);
			label: 'Add variable';
			action: [  ];
			yourself);
		add: (self newToolbarButton
			icon: ((PvCompositeIcon newName: 'method') addNew; addClass; buildOn: self);
			label: 'Add class method';
			action: [  ];
			yourself);
		add: (self newToolbarButton
			icon: ((PvCompositeIcon newName: 'method') addNew; buildOn: self);
			label: 'Add method';
			action: [  ];
			yourself);
		yourself
]

{ #category : #initialization }
PvOutlineView >> updatePresenter [

	self model ifNil: [ ^ self ].
	outlineTreePresenter 
		roots: { self model };
		expandRoots.
	
	"self withTileWindowDo: [ :w | 
		w title: self title.
		w windowIcon: (self model windowIconComposite buildOn: self application) ]"
]
