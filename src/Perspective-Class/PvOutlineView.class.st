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

{ #category : #'accessing - actions' }
PvOutlineView class >> defineActionGroupNew: actionGroup [
	<perspectiveActionGroup: #actionNew>

	actionGroup 
		priority: 10;
		name: 'New';
		beDisplayedAsSubMenu
]

{ #category : #'accessing - actions' }
PvOutlineView class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #actionNew with: {
			PvNewMethodCommand new.
			PvNewClassMethodCommand new.
			PvNewVariableCommand new.
			PvNewClassVariableCommand new. 
		}

]

{ #category : #'private - events' }
PvOutlineView >> classChanged: aModel [

	aModel isOutlineClassEntity ifFalse: [ ^ self ].
	self model: aModel asOutlineClassModel
]

{ #category : #initialization }
PvOutlineView >> connectPresenters [

	outlineTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self selectWith: aSelection ].
	outlineTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self activateWith: aSelection ]
]

{ #category : #initialization }
PvOutlineView >> contextMenuActionGroups [

	^ #(actionNew)
]

{ #category : #layout }
PvOutlineView >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: outlineTreePresenter;
		yourself
]

{ #category : #'private - events' }
PvOutlineView >> entityActivated: aModel [

	aModel isOutlineClassEntity ifFalse: [ ^ self ].
	self model: aModel asOutlineClassModel.
	self updatePresenter
]

{ #category : #'private - events' }
PvOutlineView >> entitySelected: aModel [
	| classModel |

	aModel isOutlineClassEntity ifFalse: [ ^ self ].
	
	outlineTreePresenter selectedItem = aModel
		ifTrue: [ ^ self ].

	classModel := aModel asOutlineClassModel.
	self model = classModel
		ifFalse: [ self model: classModel ].
	outlineTreePresenter selectItem: aModel
]

{ #category : #'private - actions' }
PvOutlineView >> filterByProtocol: aProtocol [

	self model toggleFilterByProtocol: aProtocol.
	self updatePresenter
]

{ #category : #initialization }
PvOutlineView >> initializePresenters [

	(outlineTreePresenter := self newTreeTable)
		hideColumnHeaders;
		addStyle: 'stTree';
		addStyle: 'pvOutlineView';
		addColumn: (SpCompositeTableColumn new
			addColumn: ( SpImageTableColumn  new 
				evaluated: [ :aModel | aModel iconComposite buildOn: self application ];
				beNotExpandable;
				yourself);
			addColumn: ( SpStringTableColumn new 
				evaluated: [ :aModel | aModel name ];
				displayColor: [ :aModel | self colorNamed: aModel colorName ];
				yourself);
			yourself);
		addColumn: (SpLinkTableColumn new 
			evaluated: [ :aModel | aModel protocol ifNil: [ '' ] ];
			displayAlignment: [ :aModel | SpColumnAlignment right ];
			action: [ :aModel | self filterByProtocol: aModel protocol ];
			beNotExpandable;
			yourself);
		children: [ :aModel | aModel children ];
		addNavigationShortcuts.
		
	outlineTreePresenter contextMenu: [ self contextMenuActions asMenuPresenter ].
	outlineTreePresenter contextKeyBindings: self contextMenuActions asKMCategory
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

{ #category : #initialization }
PvOutlineView >> toolbar [

	^ self instantiate: PvHeaderBar
	"self buildPerspectiveToolbarWith: [ :builder |
		builder 
			from: PvClassCommand;
			actionGroup: #action ]"
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
