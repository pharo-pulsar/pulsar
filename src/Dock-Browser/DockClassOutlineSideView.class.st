Class {
	#name : 'DockClassOutlineSideView',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'listPresenter',
		'listToolbarPresenter',
		'variablesToolbarPresenter',
		'variablesListPresenter',
		'protocolToolbarPresenter',
		'protocolListPresenter',
		'activeVariable',
		'activeProtocol',
		'updating',
		'actions'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineActionGroupMethod: actionGroup [
	<perspectiveActionGroup: #method>
	
	actionGroup 
		name: 'Method';
		priority: 10;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineActionGroupMethodCritical: actionGroup [
	<perspectiveActionGroup: #methodCritical>
	
	actionGroup 
		name: 'DANGER';
		priority: 1000;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineActionGroupProtocol: actionGroup [
	<perspectiveActionGroup: #protocol>
	
	actionGroup 
		name: 'Protocol';
		priority: 10;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineActionGroupProtocolCritical: actionGroup [
	<perspectiveActionGroup: #protocolCritical>
	
	actionGroup 
		name: 'DANGER';
		priority: 1000;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineActionGroupVariable: actionGroup [
	<perspectiveActionGroup: #variable>
	
	actionGroup 
		name: 'Method';
		priority: 10;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineActionGroupVariableCritical: actionGroup [
	<perspectiveActionGroup: #variableCritical>
	
	actionGroup 
		name: 'DANGER';
		priority: 1000;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineMethodActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #method with: { 
			DockNewMethodCommand new.
		};
		registerGroup: #methodCritical with: {
			$x mod1 shift -> DockRemoveMethodCommand new.
		}
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineProtocolActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #protocol with: { 
			DockNewProtocolCommand new.
		};
		registerGroup: #protocolCritical with: {
			$x mod1 -> DockRemoveProtocolCommand new.
		}
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineVariableActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #variable with: { 
			DockNewVariableCommand new.
		};
		registerGroup: #variableCritical with: {
			$x mod1 -> DockRemoveVariableCommand new.
		}
]

{ #category : 'accessing' }
DockClassOutlineSideView >> actions [

	^ actions ifNil: [ actions := PvActionCollector collectFor: self ]
]

{ #category : 'private' }
DockClassOutlineSideView >> collectProtocols [

	^ self subclassResponsibility
]

{ #category : 'private' }
DockClassOutlineSideView >> collectVariables [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
DockClassOutlineSideView >> connectPresenters [

	variablesListPresenter 
		transmitDo: [ :anEntity | self filterMethodsByVariable: anEntity ].
	protocolListPresenter 
		transmitDo: [ :anEntity | self filterMethodsByProtocol: anEntity ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self owner notifyActivateEntity: anEntity ]
]

{ #category : 'api - focus' }
DockClassOutlineSideView >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
DockClassOutlineSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		positionOfSlider: 360;
		add: (SpPanedLayout newVertical 
			positionOfSlider: 180;
			add: (SpBoxLayout newVertical
				add: variablesToolbarPresenter expand: false;
				add: variablesListPresenter;
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

{ #category : 'private - actions' }
DockClassOutlineSideView >> doAddProtocolCommand: aCommand [
	| dialog sem protocolName |

	dialog := self instantiate: DockRequestPresenter.
	dialog label: 'Protocol Name'.
	dialog acceptLabel: 'Add'.
	
	sem := Semaphore new.
	self newPopover
		presenter: dialog;
		relativeTo: aCommand presenter;
		whenClosedDo: [ sem signal ];
		popupModal.
	sem wait.

	dialog isOk ifFalse: [ ^ self ].
	
	protocolName := dialog text.
	self model asClassModel addProtocolNamed: protocolName.
	self updateProtocols.
	protocolListPresenter selectItem: (protocolListPresenter items detect: [ :each | each name = protocolName ])
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doAddVariableCommand: aCommand [
	| variableDefinition dialog result sem |
	
	variableDefinition := DockNewSlotModel new.
	dialog := self instantiate: DockNewSlotPresenter on: variableDefinition.
	
	self flag: #TODO. "Should I abstract the 'modal' popup?"
	sem := Semaphore new.
	self newPopover
		presenter: dialog;
		relativeTo: aCommand presenter;
		whenClosedDo: [ sem signal ];
		popupModal.
	sem wait.
	
	dialog isOk ifFalse: [ ^ self ].
	
	self model asClassModel 
		addVariableNamed: variableDefinition name 
		type: variableDefinition slotType.
	self updateVariables.
	variablesListPresenter selectItem: (variablesListPresenter items 
		detect: [ :each | each name = variableDefinition name ]).
	self owner notifyEntityChanged: self model asClassModel
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doForceRemoveMethod [
	"Fordcefully remove a method (without passing through the refactor remove implementation
	 that will check all usages, etc.)"
	| okToRemove selectedMethodModel |
	
	selectedMethodModel := listPresenter selectedItem. 
	selectedMethodModel ifNil: [ ^ self ].
	
	okToRemove := self application newConfirm
		title: 'Remove method';
		label: ('Do you want to remove method {1}?' format: { selectedMethodModel name });
		acceptLabel: 'Remove';
		openModalWithParent: self window.
	okToRemove ifFalse: [ ^ self ].
	
	selectedMethodModel removeMethod.
	self owner notifyEntityRemoved: selectedMethodModel.
	self updatePresenter
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doRemoveSelectedProtocol [
	| protocolModel okToRemove |

	protocolModel := protocolListPresenter selectedItem.
	protocolModel ifNil: [ ^ self ].
	
	okToRemove := self application newConfirm 
		title: 'Remove protocol';
		label: ('Do you really want to remove protocol "{1}" and all its methods?' format: { protocolModel name });
		acceptLabel: 'Remove';
		openModalWithParent: self window.
	okToRemove ifFalse: [ ^ self ].
	
	self halt
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doRequestNewMethod [

	self flag: #TODO. "I am using owner, which introcuces perhaps an undesirable coupling..."
	self owner notifyActivateEntity: self newMethodModelForNewMethod
]

{ #category : 'private' }
DockClassOutlineSideView >> filterMethodsByProtocol: aProtocolModel [

	activeProtocol := aProtocolModel.
	self updateMethods
]

{ #category : 'private' }
DockClassOutlineSideView >> filterMethodsByVariable: aVariableModel [

	activeVariable := aVariableModel.
	self updateMethods
]

{ #category : 'testing' }
DockClassOutlineSideView >> includesModel: aModel [

	^ listPresenter items includes: aModel
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initialize [

	super initialize.
	updating := false
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initializeMethods [

	listToolbarPresenter := self instantiate: DockToolbarPresenter.
	listToolbarPresenter actions:  (self actions actionsFor: #method).

	listPresenter := self newEasyListView 
		addStyle: 'stList';
		addStyle: 'dockMethodList';
		display: [ :aModel | aModel name ];
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: (self actions actionsForAll: #(method methodCritical));
		yourself	
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initializePresenters [

	self initializeVariables.
	self initializeProtocols.
	self initializeMethods
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initializeProtocols [

	protocolToolbarPresenter := self instantiate: DockToolbarPresenter.
	protocolToolbarPresenter actions: (self actions actionsFor: #protocol).

	protocolListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockProtocolList';
		rowPresenterClass: DockProtocolRow;
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: (self actions actionsForAll: #(protocol protocolCritical));
		yourself
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initializeVariables [

	variablesToolbarPresenter := self instantiate: DockToolbarPresenter.
	variablesToolbarPresenter actions: (self actions actionsFor: #variable).

	variablesListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockVariablesList';
		rowPresenterClass: DockSlotRow;
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: (self actions actionsForAll: #(variable variableCritical));
		yourself
]

{ #category : 'initialization' }
DockClassOutlineSideView >> listToolbarActions [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Add';
			iconName: #add;
			description: 'Add a new method';
			action: [ self doRequestNewMethod ] ]
]

{ #category : 'private' }
DockClassOutlineSideView >> methodsForProtocol: aProtocolModel [

	self subclassResponsibility
]

{ #category : 'private' }
DockClassOutlineSideView >> methodsForVariable: aVariableModel [

	self subclassResponsibility
]

{ #category : 'private' }
DockClassOutlineSideView >> newMethodModelForNewMethod [

	self subclassResponsibility
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updateMethods [
	| items |

	updating ifTrue: [ ^ self ].
	items := self methodsForProtocol: activeProtocol.	
	activeVariable ifNotNil: [ 
		items := items select: [ :each | each isUsingVariable: activeVariable ] ].
	listPresenter items: items
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updatePresenter [ 

	self model ifNil: [ ^ self ].
	
	"I defer to make the update happen at one in UI thread (it looks smoother)"
	self application defer: [
		"prevent update methods until is its time"
		self updatingWhile: [
			self updateVariables.
			self updateProtocols.
			activeProtocol := protocolListPresenter selectedItem ].
		"update methods happens outside the updating flag... :P"
		self updateMethods ]
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updateProtocols [

	protocolListPresenter updateItemsKeepingSelection: self collectProtocols.
	protocolListPresenter selectedItem 
		ifNil: [ protocolListPresenter selectFirst ]
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updateVariables [

	variablesListPresenter updateItemsKeepingSelection: self collectVariables.
	variablesListPresenter selectedItem 
		ifNil: [ variablesListPresenter selectFirst ].
	activeVariable := variablesListPresenter selectedItem
]

{ #category : 'private - updating' }
DockClassOutlineSideView >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : 'visiting' }
DockClassOutlineSideView >> visitClassModel: aModel [

	listPresenter unselectAll.
	variablesListPresenter unselectAll
]

{ #category : 'visiting' }
DockClassOutlineSideView >> visitMethodModel: aModel [
	| protocolModel |

	protocolModel := aModel protocolModel.
	"update protocols in case I have a new one or my current editing 
	 method is not included in the method list."
	((protocolListPresenter items includes: protocolModel)
		and: [ listPresenter items includes: aModel ])
		"ifTrue: [ self updateMethods ]"
		ifFalse: [ self updateProtocols ].
	
	listPresenter
		selectItem: aModel
		scrollToSelection: true
]
