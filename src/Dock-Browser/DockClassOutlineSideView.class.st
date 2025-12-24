"
This is the base for a ""side"" in the class outline view. 
Conceptually (bah, not quitte ""conceptually"", but common way of call the fact that a class is create by another class -- the ""metaclass"", which is known as ""class side"" in general).
We will extend the ""side"" concept to traits: traits are extra ""sides"" in a multidimensional fashion :)

"
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
		'updating',
		'actions',
		'activeProtocols',
		'activeVariables',
		'previewPopoverActive',
		'previewPopover'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineMethodActionsOn: aBuilder [
	<dockActions>
	
	aBuilder 
		addGroup: #method with: [ :group | group
			priority: 10;
			name: 'Method';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'New method';
				description: 'Add a new method to this class';
				iconName: 'add';
				action: [ :aContext | aContext doRequestNewMethod ] ] ];
		addGroup: #methodCritical with: [ :group | group 
			priority: 1000;
			name: 'DANGER ZONE';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'Force remove method';
				description: 'Remove this method (without cheching for usages)';
				shortcutKey: $x mod1 shift;
				action: [ :aContext | aContext doForceRemoveMethod ] ] ]
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineProtocolActionsOn: aBuilder [
	<dockActions>
	
	aBuilder 
		addGroup: #protocol with: [ :group | group 
			priority: 10;
			name: 'Protocol';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'New protocol';
				description: 'Add a new protocol to this class';
				iconName: 'add';
				shortcutKey: $n mod1;
				action: [ :aContext | aContext doAddProtocolCommand: action ] ];
			addActionWith: [ :action | action 
				name: 'Rename';
				shortcutKey: $r mod1;
				description: 'Rename protocol';
				action: [ :aContext | aContext doRenameProtocolCommand: action ] ] ];
		addGroup: #protocolCritical with: [ :group | group
			priority: 1000;
			name: 'DANGER ZONE';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'Remove protocol';
				description: 'Remove this protocol and all its methods?';
				shortcutKey: $x mod1;
				action: [ :aContext | aContext doRemoveSelectedProtocol ] ] ]
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineVariableActionsOn: aBuilder [
	<dockActions>
	
	aBuilder 
		addGroup: #variable with: [ :group | group
			priority: 10;
			name: 'Variables';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'New slot';
				description: 'Add a new slot to this class';
				iconName: 'add';
				action: [ :aContext | aContext doAddVariableCommand: action ] ] ];
		addGroup: #variableCritical with: [ :group | group
			priority: 1000;
			name: 'DANGER ZONE';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'Remove slot';
				description: 'Remove this slot';
				shortcutKey: $x mod1;
				action: [ :aContext | aContext doRemoveVariable ] ] ]
]

{ #category : 'accessing' }
DockClassOutlineSideView >> actions [

	^ actions ifNil: [ actions := DockActionCollector collectFor: self ]
]

{ #category : 'private - preview' }
DockClassOutlineSideView >> activateMethodPreviewPopover [
	
	(self isPreviewPopoverActive 
		and: [ previewPopover isNotNil 
		and: [ previewPopover isVisible ] ]) 
		ifTrue: [
			"Second arrow right will transfer focus"
			previewPopover takeKeyboardFocus.
			^ self ].
	
	previewPopoverActive := true.
	self maybePopupPreview
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
		transmitDo: [ :aCollection | self filterMethodsByVariable: aCollection ].
	protocolListPresenter 
		transmitDo: [ :aCollection | self filterMethodsByProtocol: aCollection ].
	listPresenter outputSelectionPort
		transmitDo: [ :anEntity | self entitySelected: anEntity ].
	listPresenter outputActivationPort 
		transmitDo: [ :anEntity | self entityActivated: anEntity ]
]

{ #category : 'private - preview' }
DockClassOutlineSideView >> deactivateMethodPreviewPopover [

	self isPreviewPopoverActive ifFalse: [ ^ self ].
	previewPopoverActive := false.
	self dismissPreview
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

{ #category : 'private - definitions' }
DockClassOutlineSideView >> defineMethodRefactorActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #methodRefactors with: [ :group | group 
		name: 'Refactors';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			dynamicName: [ 'Rename {1}' format: { self selectedMethodName } ];
			description: [ 'Rename method' ];
			actionEnabled: [ self hasSelectedMethod ];
			action: [ self doRenameMethod ] ];
		addActionWith: [ :action | action
			dynamicName: [ 'Pull up {1}' format: { self selectedMethodName } ];
			description: [ 'Pullup method' ];
			actionEnabled: [ self hasSelectedMethod ];
			action: [ self doPullUpMethod ] ];
		addActionWith: [ :action | action
			dynamicName: [ 'Push down {1}' format: { self selectedMethodName } ];
			description: [ 'Push down method' ];
			actionEnabled: [ self hasSelectedMethod ];
			action: [ self doPushUpMethod ] ] ]
]

{ #category : 'private - preview' }
DockClassOutlineSideView >> dismissPreview [
	logger trace.

	previewPopover ifNil: [ ^ self ].
	
	previewPopover dismiss.
	previewPopover := nil
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doAddProtocolCommand: aCommand [
	| dialog protocolName |

	dialog := self instantiate: DockRequestPresenter.
	dialog label: 'Protocol Name'.
	dialog acceptLabel: 'Add'.
	
	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].
	
	protocolName := dialog text.
	self model asClassModel addProtocolNamed: protocolName.
	self updateProtocols.
	protocolListPresenter selectItem: (protocolListPresenter items detect: [ :each | each name = protocolName ])
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doAddVariableCommand: aCommand [
	| variableDefinition dialog result |
	
	variableDefinition := DockNewSlotModel new.
	dialog := self instantiate: DockNewSlotPresenter on: variableDefinition.
	
	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
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
		message: ('Do you want to remove method {1}?' format: { selectedMethodModel name });
		acceptLabel: 'Remove';
		openModalWithParent: self window.
	okToRemove ifFalse: [ ^ self ].

	selectedMethodModel removeMethod.
	self owner notifyEntityRemoved: selectedMethodModel.
	self updatePresenter
]

{ #category : 'private - refactors' }
DockClassOutlineSideView >> doPullUpMethod [

	self schedule: [
		(RePullUpMethodDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pullUpMethods: { self selectedMethod entity };
			runRefactoring ]
]

{ #category : 'private - refactors' }
DockClassOutlineSideView >> doPushDownMethod [

	self schedule: [
		(RePushDownMethodDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pushDownMethods: { self selectedMethod entity };
			runRefactoring ]	
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doRemoveSelectedProtocol [

	| protocolModel okToRemove |
	protocolModel := protocolListPresenter selectedItem.
	protocolModel ifNil: [ ^ self ].

	okToRemove := self application newConfirm
		              title: 'Remove protocol';
		              message: ('Do you really want to remove protocol "{1}" and all its methods?' format: { protocolModel name });
		              acceptLabel: 'Remove';
		              openModalWithParent: self window.
	okToRemove ifFalse: [ ^ self ].

	self halt
]

{ #category : 'private - refactors' }
DockClassOutlineSideView >> doRenameMethod [

	self application schedule: [ 
		| rbClasses rbModel method |
		
		method := self selectedMethod entity.
		rbClasses := RBClassEnvironment classes: method methodClass withAllSubclasses.
		rbModel := RBNamespace onEnvironment: rbClasses.
		(ReRenameMethodDriver newApplication: self application)
			scopes: { rbClasses }
				model: rbModel
				renameMethodSignature: method
				in: method methodClass;
			runRefactoring ]
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doRenameProtocolCommand: anAction [
	| dialog protocolName selectedProtocolModel |

	selectedProtocolModel := protocolListPresenter selectedItem.
	selectedProtocolModel ifNil: [ ^ self ].
	self flag: #TODO. "Validate can be renamed (e.g. if is virtual, but this should be 
	by enable/disable the option in the menu)"

	dialog := self instantiate: DockRequestPresenter.
	dialog 
		label: 'Protocol Name';
		text: selectedProtocolModel name.
	dialog acceptLabel: 'Rename'.
	
	dialog asPopover
		relativeTo: (protocolListPresenter selectedRowPresenter ifNil: [ protocolListPresenter ]);
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].
	
	protocolName := dialog text.
	selectedProtocolModel renameProtocolTo: protocolName.
	self updateProtocols.
	protocolListPresenter 
		selectItem: (protocolListPresenter items detect: [ :each | each name = protocolName ])
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doRequestNewMethod [

	self flag: #TODO. "I am using owner, which introcuces perhaps an undesirable coupling..."
	self owner notifyActivateEntity: self newMethodModelForNewMethod
]

{ #category : 'private' }
DockClassOutlineSideView >> entityActivated: anEntity [

	self owner schedule: [ 
		self deactivateMethodPreviewPopover ].
	self owner notifyActivateEntity: anEntity
]

{ #category : 'private' }
DockClassOutlineSideView >> entitySelected: anEntity [

	anEntity ifNil: [ ^ self ].

	logger trace: anEntity.

	self maybePopupPreview.
  
	self owner notifySelectEntity: anEntity
]

{ #category : 'private' }
DockClassOutlineSideView >> filterMethodsByProtocol: aCollection [

	activeProtocols := aCollection.
	self updateMethods
]

{ #category : 'private' }
DockClassOutlineSideView >> filterMethodsByVariable: aVariableModel [

	activeVariables := aVariableModel.
	self updateMethods
]

{ #category : 'private - testing' }
DockClassOutlineSideView >> hasSelectedMethod [

	^ self selectedMethod isNotNil
]

{ #category : 'testing' }
DockClassOutlineSideView >> includesModel: aModel [

	^ listPresenter items includes: aModel
]

{ #category : 'testing' }
DockClassOutlineSideView >> includesModelSuchAs: aBlock [

	^ listPresenter items anySatisfy: aBlock 
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initialize [

	super initialize.
	previewPopoverActive := false.
	updating := false
]

{ #category : 'initialization' }
DockClassOutlineSideView >> initializeMethods [

	listToolbarPresenter := self instantiate: DockToolbarPresenter.
	listToolbarPresenter actions:  (self actions actionsFor: #method).

	listPresenter := self newFilteringList 
		addStyle: 'stList';
		addStyle: 'dockMethodList';
		rowPresenterClass: DockMethodRow;
		display: [ :aModel | aModel name ];
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: (SpActionGroup new 
			add: (self actions actionsForAll: #(method methodRefactors methodCritical));
			addShortcutWith: [ :action | action 
				shortcutKey: KeyboardKey left asKeyCombination;
				action: [ self activateMethodPreviewPopover ] ];
			addShortcutWith: [ :action | action 
				shortcutKey: KeyboardKey right asKeyCombination | KeyboardKey escape asKeyCombination;
				action: [ self deactivateMethodPreviewPopover ] ];
			yourself);
		yourself.
		
	listPresenter eventHandler 
		whenFocusLostDo: [ self deactivateMethodPreviewPopover ]
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
		beMultipleSelection;
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
		beMultipleSelection;
		rowPresenterClass: DockSlotRow;
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: (self actions actionsForAll: #(variable variableCritical));
		yourself
]

{ #category : 'private - preview' }
DockClassOutlineSideView >> isPreviewPopoverActive [

	^ previewPopoverActive
]

{ #category : 'private - accessing' }
DockClassOutlineSideView >> listPresenter [

	^ listPresenter
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

{ #category : 'private - preview' }
DockClassOutlineSideView >> maybePopupPreview [
	| active |

	active := self isPreviewPopoverActive.
	logger trace: active.

	active ifFalse: [ ^ self ].
	self owner schedule: [ 
		self popupPreview ]
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

{ #category : 'private - announcing' }
DockClassOutlineSideView >> notifyEntityRemoved: anEntity [

	self owner notifyEntityRemoved: anEntity
]

{ #category : 'private - preview' }
DockClassOutlineSideView >> popupPreview [
	| selectedModel editorPresenter |
	
	logger trace.

	previewPopover ifNotNil: [ self dismissPreview ].

	selectedModel := listPresenter selectedItem.
	selectedModel ifNil: [ ^ self ].
	
	previewPopover := self newPopover.
	
	"is important to instantiate the popover as a child of the popover"
	editorPresenter := (previewPopover 
			instantiate: DockMethodEditor 
			on: selectedModel)
		addStyle: 'dockPreviewEditor';
		notificationCenter: self owner notificationCenter;
		yourself.
		
	self flag: #TODO. "we need to check for left-right depending on the position of the overview"
	previewPopover
		bePositionLeft;
		doNotTransferFocus;
		relativeTo: (listPresenter selectedRowPresenter ifNil: [ listPresenter ]);
		presenter: editorPresenter;
		popup
]

{ #category : 'initialization' }
DockClassOutlineSideView >> resetInteractionStatus [

	"in case is active"
	self dismissPreview
]

{ #category : 'private' }
DockClassOutlineSideView >> schedule: aBlock [

	self owner schedule: aBlock
]

{ #category : 'private - accessing' }
DockClassOutlineSideView >> selectedMethod [

	^ listPresenter selectedItem
]

{ #category : 'private - accessing' }
DockClassOutlineSideView >> selectedMethodName [

	^ self selectedMethod 
		ifNotNil: [ :aModel | aModel name ]
		ifNil: [ 'Unknown' ]
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updateMethods [
	| items |
	
	updating ifTrue: [ ^ self ].

	logger trace.

	items := activeProtocols 
		flatCollect: [ :each | self methodsForProtocol: each ]
		as: OrderedCollection.	
	activeVariables ifNotEmpty: [
		items := items select: [ :each | each isUsingAnyVariable: activeVariables ] ].
	listPresenter updateItemsKeepingSelection: items
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updatePresenter [ 

	self model ifNil: [ ^ self ].
	
	logger trace.
	
	"I defer to make the update happen at one in UI thread (it looks smoother)"
	self application defer: [
		"prevent update methods until is its time"
		self updatingWhile: [
			self updateVariables.
			self updateProtocols ].
		"update methods happens outside the updating flag... :P"
		self updateMethods ]
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updateProtocols [

	logger trace.
	
	protocolListPresenter updateItemsKeepingSelection: self collectProtocols.
	protocolListPresenter selectedItems
		ifEmpty: [ protocolListPresenter selectFirst ].
	activeProtocols := protocolListPresenter selectedItems
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updateVariables [

	logger trace. 

	variablesListPresenter updateItemsKeepingSelection: self collectVariables.
	variablesListPresenter selectedItems
		ifEmpty: [ variablesListPresenter selectFirst ].
	activeVariables := variablesListPresenter selectedItems
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
	"update the list after a model changes. 
	 this should not trigger new events."
	| protocolModel isSameModel |
		
	logger trace: aModel.

	"look for the method (but check for isSameAs:, as the method can be changed and then in 
	 practice is another method). This is just a guard, in general is not needed"	 
	listPresenter items
		detect: [ :each | each isSameAs: aModel ] 
		ifFound: [ :oldModel |
			logger trace: oldModel = aModel.
			oldModel = aModel ifFalse: [
				listPresenter items 
					replaceAll: oldModel 
					with: aModel ] ].

	logger trace: listPresenter selectedItem.

	protocolModel := aModel protocolModel.
	"update protocols in case I have a new one or my current editing 
	 method is not included in the method list."
	((protocolListPresenter items includes: protocolModel)
		and: [ (listPresenter items includes: aModel) ])
		"ifTrue: [ self updateMethods ]"
		ifFalse: [ self updateProtocols ].
	 
	"need to reset the selection first otherwise the list will not be updated 
	 (and I need it to be)"
	self application defer: [
		listPresenter disableActivationDuring: [
			listPresenter unselectAll.
			listPresenter
				selectItem: aModel
				scrollToSelection: true ] ]
]
