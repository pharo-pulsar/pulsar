Class {
	#name : 'PvOutlineView',
	#superclass : 'PvPerspectiveView',
	#instVars : [
		'classTreePresenter',
		'outlineTreePresenter',
		'toolbar'
	],
	#category : 'Perspective-Class-View',
	#package : 'Perspective-Class',
	#tag : 'View'
}

{ #category : 'accessing' }
PvOutlineView class >> defaultContainerName [

	^ #overview
]

{ #category : 'accessing' }
PvOutlineView class >> defaultTitle [

	^ 'Outline'
]

{ #category : 'accessing - actions' }
PvOutlineView class >> defineActionGroupAction: actionGroup [
	<perspectiveActionGroup: #action>

	actionGroup 
		priority: 20;
		name: 'Actions';
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
PvOutlineView class >> defineActionGroupNew: actionGroup [
	<perspectiveActionGroup: #actionNew>

	actionGroup 
		priority: 10;
		name: 'New';
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
PvOutlineView class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #actionNew with: {
			$n mod1 -> PvNewMethodCommand new.
			PvNewVariableCommand new.
		};
		registerGroup: #action with: {
			$x mod1 -> PvRemoveMethodCommand new.
		}
]

{ #category : 'private - events' }
PvOutlineView >> classChanged: aModel [

	aModel isOutlineClassEntity ifFalse: [ ^ self ].
	self model: aModel asOutlineClassModel
]

{ #category : 'initialization' }
PvOutlineView >> connectPresenters [

	outlineTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self selectWith: aSelection ].
	outlineTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self activateWith: aSelection ]
]

{ #category : 'initialization' }
PvOutlineView >> contextMenuActionGroups [

	^ #(actionNew action)
]

{ #category : 'layout' }
PvOutlineView >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: outlineTreePresenter;
		yourself
]

{ #category : 'private - events' }
PvOutlineView >> entityActivated: aModel [
	| outlineModel |

	aModel isOutlineClassEntity ifFalse: [ ^ self ].
	
	outlineModel := aModel asOutlineClassModel.
	"do not update if already there"
	outlineModel = self model ifTrue: [ ^ self ].
	
	self model: outlineModel.
	self updatePresenter
]

{ #category : 'private - events' }
PvOutlineView >> entitySelected: aModel [
	| classModel |

	aModel isOutlineClassEntity ifFalse: [ ^ self ].
	
	outlineTreePresenter selectedItem = aModel
		ifTrue: [ ^ self ].

	classModel := aModel asOutlineClassModel.
	self model = classModel
		ifFalse: [ self model: classModel ].

	"if this is the same entity, do not try to select (since it does not has sense anyway)"
	self model entity = aModel entity 
		ifTrue: [ outlineTreePresenter unselectAll ]
		ifFalse: [ outlineTreePresenter selectItem: aModel ]
]

{ #category : 'private - actions' }
PvOutlineView >> filterByProtocol: aProtocol [

	self model toggleFilterByProtocol: aProtocol.
	self updatePresenter
]

{ #category : 'initialization' }
PvOutlineView >> initializePresenters [

	(outlineTreePresenter := self newTreeColumnView)
		addStyle: 'stTree';
		addStyle: 'pvOutlineView';
		addColumn: (SpColumnViewColumn 
			newTitle: 'Element' 
			setup: [ :aPresenter | 
				| p |
				(p := aPresenter newPresenter) 
					layout: (SpBoxLayout newHorizontal
						add: p newImage expand: false;
						add: p newLabel;
						yourself);
					yourself ] 
			bind: [ :aPresenter :aModel | | c | 
				c := aPresenter layout children.
				c first image: (self iconNamed: aModel iconName).
				c second label: aModel name ]);
		addColumn: ((SpColumnViewColumn 
			newTitle: 'Protocol' 
			setup: [ :aPresenter | 
				aPresenter newLink
					action: [ :aModel | self filterByProtocol: aModel protocol ];
					yourself ] 
			bind: [ :aPresenter :aModel | 
				aModel protocol 
					ifNotNil: [ :aProtocol | aPresenter label: aProtocol name; show ]
					ifNil: [ aPresenter hide ] ])
			beNotExpandable);
		children: [ :aModel |
			aModel children ];
		actions: self contextMenuActions
]

{ #category : 'initialization' }
PvOutlineView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter toolbar: self toolbar
]

{ #category : 'private - events' }
PvOutlineView >> methodChanged: aModel [

	outlineTreePresenter roots: { self model }.
	outlineTreePresenter selectItem: aModel
]

{ #category : 'initialization' }
PvOutlineView >> toolbar [

	^ (self instantiate: PvHeaderBarPresenter)
		toolbarActions: (self actions actionsForAll: #(actionNew));
		yourself
]

{ #category : 'initialization' }
PvOutlineView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	outlineTreePresenter items: self model children.
	
	self withTileWindowDo: [ :w | 
		w title: self title.
		w windowIcon: (self model windowIconComposite buildOn: self application) ]
]
