Class {
	#name : #PvOutlineView,
	#superclass : #PvPerspectiveView,
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

{ #category : #'private - events' }
PvOutlineView >> classActivated: aModel [

	self model: aModel newOutlineClassModel.
	self updatePresenter	
]

{ #category : #'private - events' }
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
		
	outlineTreePresenter addStyle: 'stProjectTree'.
	outlineTreePresenter contextMenu: [ self toolbarActions asMenuPresenter ].
	outlineTreePresenter contextKeyBindings: self toolbarActions asKMCategory
]

{ #category : #initialization }
PvOutlineView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter toolbar: self toolbar
]

{ #category : #'private - events' }
PvOutlineView >> methodChanged: aModel [

	outlineTreePresenter roots: { self model }.
	outlineTreePresenter selectItem: aModel
]

{ #category : #'private - events' }
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
		fillWith: self toolbarActions
]

{ #category : #initialization }
PvOutlineView >> toolbarActions [
	| group |
	
	group := (CmCommandGroup named: 'Class') asSpecGroup.
	group beRoot.
	PvClassCommand allCommands do: [ :each |
		group register: (each forSpecContext: self) ].
	
	^ group
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
