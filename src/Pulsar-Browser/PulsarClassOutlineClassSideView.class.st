Class {
	#name : 'PulsarClassOutlineClassSideView',
	#superclass : 'PulsarClassOutlineSideView',
	#instVars : [
		'sharedVariablesToolbarPresenter',
		'sharedVariablesListPresenter'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'private - actions' }
PulsarClassOutlineClassSideView >> addVariableName: aName type: aType [
	
	self model asClassModel 
		addClassVariableNamed:  aName
		type: aType
]

{ #category : 'private' }
PulsarClassOutlineClassSideView >> collectProtocols [

	^ self model collectClassProtocols
]

{ #category : 'private' }
PulsarClassOutlineClassSideView >> collectSharedVariables [

	^  self model collectClassSharedVariables
]

{ #category : 'private' }
PulsarClassOutlineClassSideView >> collectVariables [

	^ self model collectClassVariables
]

{ #category : 'private - definitions' }
PulsarClassOutlineClassSideView >> defineSharedVariableActionsOn: aBuilder [
	<dockActions>
	
	aBuilder 
		addGroup: #sharedVariable with: [ :group | group
			priority: 10;
			name: 'Variables';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'New shared variable';
				description: 'Add a new shared variable to this class';
				iconName: 'add';
				action: [ self doAddSharedVariableCommand: action ] ] ];
		addGroup: #sharedVariableCritical with: [ :group | group
			priority: 1000;
			name: 'DANGER ZONE';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				dynamicName: [ 'Remove {1}' format: { self selectedSharedVariableName }  ];
				description: 'Remove this shared variable';
				shortcutKey: $x mod1 shift;
				action: [ self doForceRemoveSharedVariable ] ] ]
]

{ #category : 'private - actions' }
PulsarClassOutlineClassSideView >> doAddSharedVariableCommand: aCommand [
	| variableName dialog |
	
	dialog := self instantiate: PulsarRequestPresenter.
	dialog label: 'Shared Variable Name'.
	dialog acceptLabel: 'Add'.
	
	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].
	variableName := dialog text.
	
	self model asClassModel addSharedVariableNamed: variableName.
	self updateSharedVariables.
	sharedVariablesListPresenter selectItem: (sharedVariablesListPresenter items
		detect: [ :each | each name = variableName ]).
	self owner notifyEntityChanged: self model asClassModel
]

{ #category : 'private - actions' }
PulsarClassOutlineClassSideView >> doAddVariableCommand: aCommand [
	"overriden because I need #useSimpleLayout.
	 When class side accept slots, we need to remove this method (and fix the variable creation)"
	| variableDefinition dialog |
	
	variableDefinition := PulsarNewSlotModel new.
	dialog := self instantiate: PulsarNewSlotPresenter on: variableDefinition.
	dialog useSimpleLayout.
	
	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].
	
	self 
		addVariableName: variableDefinition name 
		type: variableDefinition slotType.
	
	self updateVariables.
	
	variablesListPresenter selectItem: (variablesListPresenter items 
		detect: [ :each | each name = variableDefinition name ]).
	self owner notifyEntityChanged: self model asClassModel
]

{ #category : 'testing' }
PulsarClassOutlineClassSideView >> hasSharedSelectedVariable [

	^ self selectedSharedVariable isNotNil
]

{ #category : 'layout' }
PulsarClassOutlineClassSideView >> horizontalLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 360;
		add: (SpPanedLayout newHorizontal 
			positionOfSlider: 200;
			add: (SpPanedLayout newHorizontal 
				add: (SpBoxLayout newVertical
					add: variablesToolbarPresenter expand: false;
					add: variablesListPresenter;
					yourself);
				add: (SpBoxLayout newVertical
					add: sharedVariablesToolbarPresenter expand: false;
					add: sharedVariablesListPresenter;
					yourself);
				yourself);
			add: (SpBoxLayout newVertical
				add: protocolToolbarPresenter expand: false;
				add: protocolListPresenter;
				yourself);
			yourself);
		add: (SpBoxLayout newVertical
			add: listToolbarPresenter expand: false;
			add: listPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
PulsarClassOutlineClassSideView >> initializePresenters [

	super initializePresenters.
	self initializeSharedVariables
]

{ #category : 'initialization' }
PulsarClassOutlineClassSideView >> initializeSharedVariables [

	sharedVariablesToolbarPresenter := self instantiate: PulsarToolbarPresenter.
	sharedVariablesToolbarPresenter actions: self sharedVariablesToolbarActions.
	
	sharedVariablesListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'pulsarSharedVariablesList';
		display: #name;
		actions: (SpActionGroup new 
			add: (self actions actionsForAll: #(sharedVariable sharedVariableCritical));
			addDynamicGroup: #dynamic with: [ :group | group add: self variableRefactorActions ];
			yourself);
		yourself
]

{ #category : 'private' }
PulsarClassOutlineClassSideView >> methodsForProtocol: aProtocolModel [

	aProtocolModel ifNil: [ ^ #() ].
	^ self model collectClassMethodsForProtocol: aProtocolModel
]

{ #category : 'private' }
PulsarClassOutlineClassSideView >> newMethodModelForNewMethod [

	^ PvMethodModel
		newEnvironment: self model environmentModel 
		beNewClassMethodWithParent: self model
]

{ #category : 'private - accessing' }
PulsarClassOutlineClassSideView >> selectedSharedVariable [

	^ sharedVariablesListPresenter selectedItem
]

{ #category : 'private - accessing' }
PulsarClassOutlineClassSideView >> selectedSharedVariableName [

	^ self selectedSharedVariable 
		ifNotNil: [ :aModel | aModel name ]
		ifNil: [ 'Unknown' ]
]

{ #category : 'private' }
PulsarClassOutlineClassSideView >> sharedVariableRefactorActions [

	self hasSharedSelectedVariable ifFalse: [ ^ SpActionGroup new ].

	^ self selectedSharedVariable actionsWithContextOn: self
]

{ #category : 'initialization' }
PulsarClassOutlineClassSideView >> sharedVariablesToolbarActions [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Add';
			description: 'Add a new shared variable';
			iconName: #add;
			action: [ :aContext | self doAddSharedVariableCommand: action ] ]	
]

{ #category : 'initialization' }
PulsarClassOutlineClassSideView >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [
		self updatingWhile: [ 
			super updatePresenter.
			sharedVariablesListPresenter items: self collectSharedVariables ] ]
]

{ #category : 'updating' }
PulsarClassOutlineClassSideView >> updateSharedVariables [
	| sharedVariables |

	sharedVariables := self collectSharedVariables.
	sharedVariablesListPresenter updateItemsKeepingSelection: self collectSharedVariables.
	(sharedVariablesListPresenter selectedItems isEmpty and: [ sharedVariables isNotEmpty ]) 
		ifTrue: [ sharedVariablesListPresenter selectFirst ].
		
	"activeSharedVariables := variablesListPresenter selectedItems"
]

{ #category : 'layout' }
PulsarClassOutlineClassSideView >> verticalLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 360;
		add: (SpPanedLayout newVertical 
			positionOfSlider: 200;
			add: (SpPanedLayout newVertical 
				add: (SpBoxLayout newVertical
					add: variablesToolbarPresenter expand: false;
					add: variablesListPresenter;
					yourself);
				add: (SpBoxLayout newVertical
					add: sharedVariablesToolbarPresenter expand: false;
					add: sharedVariablesListPresenter;
					yourself);
				yourself);
			add: (SpBoxLayout newVertical
				add: protocolToolbarPresenter expand: false;
				add: protocolListPresenter;
				yourself);
			yourself);
		add: (SpBoxLayout newVertical
			add: listToolbarPresenter expand: false;
			add: listPresenter;
			yourself);
		yourself
]

{ #category : 'visiting' }
PulsarClassOutlineClassSideView >> visitClassModel: aModel [
	
	super visitClassModel: aModel.
	sharedVariablesListPresenter unselectAll
]

{ #category : 'visiting' }
PulsarClassOutlineClassSideView >> visitMethodModel: aModel [

	aModel isInstanceSide ifTrue: [ ^ self ].
	^ super visitMethodModel: aModel
]
