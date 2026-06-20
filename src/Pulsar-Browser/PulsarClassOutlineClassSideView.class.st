Class {
	#name : 'PulsarClassOutlineClassSideView',
	#superclass : 'PulsarClassOutlineSideView',
	#instVars : [
		'sharedVariablesToolbarPresenter',
		'sharedVariablesPresenter'
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
	sharedVariablesPresenter selectItem: (sharedVariablesPresenter items
		detect: [ :each | each name = variableName ]).
	self owner notifyEntityChanged: self model asClassModel
]

{ #category : 'private - actions' }
PulsarClassOutlineClassSideView >> doAddVariableCommand: aCommand [
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
					add: sharedVariablesPresenter;
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
	
	sharedVariablesPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'pulsarSharedVariablesList';
		display: #name;
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
			sharedVariablesPresenter items: self collectSharedVariables ] ]
]

{ #category : 'updating' }
PulsarClassOutlineClassSideView >> updateSharedVariables [
	| sharedVariables |

	sharedVariables := self collectSharedVariables.
	sharedVariablesPresenter updateItemsKeepingSelection: self collectSharedVariables.
	(sharedVariablesPresenter selectedItems isEmpty and: [ sharedVariables isNotEmpty ]) 
		ifTrue: [ sharedVariablesPresenter selectFirst ].
		
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
					add: sharedVariablesPresenter;
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
	sharedVariablesPresenter unselectAll
]

{ #category : 'visiting' }
PulsarClassOutlineClassSideView >> visitMethodModel: aModel [

	aModel isInstanceSide ifTrue: [ ^ self ].
	^ super visitMethodModel: aModel
]
