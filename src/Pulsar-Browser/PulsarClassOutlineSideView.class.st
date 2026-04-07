"
This is the base for a ""side"" in the class outline view. 
Conceptually (bah, not quitte ""conceptually"", but common way of call the fact that a class is create by another class -> the ""metaclass"", which is known as ""class side"" in general).
We will extend the ""side"" concept to traits: traits are extra ""sides"" in a multidimensional fashion :)

"
Class {
	#name : 'PulsarClassOutlineSideView',
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
		'previewPopover',
		'usingLayout'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'accessing - actions' }
PulsarClassOutlineSideView class >> defineMethodActionsOn: aBuilder [
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
PulsarClassOutlineSideView class >> defineProtocolActionsOn: aBuilder [
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
PulsarClassOutlineSideView class >> defineVariableActionsOn: aBuilder [
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
PulsarClassOutlineSideView >> actions [

	^ actions ifNil: [ actions := PulsarActionCollector collectFor: self ]
]

{ #category : 'private - preview' }
PulsarClassOutlineSideView >> activateMethodPreviewPopover [
	
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
PulsarClassOutlineSideView >> collectProtocols [

	^ self subclassResponsibility
]

{ #category : 'private' }
PulsarClassOutlineSideView >> collectVariables [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> connectPresenters [

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
PulsarClassOutlineSideView >> deactivateMethodPreviewPopover [

	self isPreviewPopoverActive ifFalse: [ ^ self ].
	previewPopoverActive := false.
	self dismissPreview
]

{ #category : 'api - focus' }
PulsarClassOutlineSideView >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
PulsarClassOutlineSideView >> defaultLayout [
	usingLayout := #vertical.
	^ self verticalLayout
]

{ #category : 'private - definitions' }
PulsarClassOutlineSideView >> defineMethodRefactorActionsOn: aBuilder [
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
PulsarClassOutlineSideView >> dismissPreview [

	logger trace.

	previewPopover ifNil: [ ^ self ].
	[ previewPopover dismiss ]
	ensure: [ 
		previewPopover := nil ]
]

{ #category : 'private - actions' }
PulsarClassOutlineSideView >> doAddProtocolCommand: aCommand [
	| dialog protocolName |

	dialog := self instantiate: PulsarRequestPresenter.
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
PulsarClassOutlineSideView >> doAddVariableCommand: aCommand [
	| variableDefinition dialog result |
	
	variableDefinition := PulsarNewSlotModel new.
	dialog := self instantiate: PulsarNewSlotPresenter on: variableDefinition.
	
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
PulsarClassOutlineSideView >> doForceRemoveMethod [
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

{ #category : 'private - actions' }
PulsarClassOutlineSideView >> doRemoveSelectedProtocol [
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

{ #category : 'private - actions' }
PulsarClassOutlineSideView >> doRenameProtocolCommand: anAction [
	| dialog protocolName selectedProtocolModel |

	selectedProtocolModel := protocolListPresenter selectedItem.
	selectedProtocolModel ifNil: [ ^ self ].
	self flag: #TODO. "Validate can be renamed (e.g. if is virtual, but this should be 
	by enable/disable the option in the menu)"

	dialog := self instantiate: PulsarRequestPresenter.
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
PulsarClassOutlineSideView >> doRequestNewMethod [

	self flag: #TODO. "I am using owner, which introcuces perhaps an undesirable coupling..."
	self owner notifyActivateEntity: self newMethodModelForNewMethod
]

{ #category : 'private' }
PulsarClassOutlineSideView >> entityActivated: anEntity [

	self owner queueTask: [ 
		self deactivateMethodPreviewPopover ].
	self owner notifyActivateEntity: anEntity
]

{ #category : 'private' }
PulsarClassOutlineSideView >> entitySelected: anEntity [

	anEntity ifNil: [ ^ self ].

	logger trace: anEntity.

	self maybePopupPreview.
  
	self owner notifySelectEntity: anEntity
]

{ #category : 'private' }
PulsarClassOutlineSideView >> filterMethodsByProtocol: aCollection [

	activeProtocols := aCollection.
	self updateMethods
]

{ #category : 'private' }
PulsarClassOutlineSideView >> filterMethodsByVariable: aVariableModel [

	activeVariables := aVariableModel.
	self updateMethods
]

{ #category : 'private - testing' }
PulsarClassOutlineSideView >> hasSelectedMethod [

	^ self selectedMethod isNotNil
]

{ #category : 'private - testing' }
PulsarClassOutlineSideView >> hasSelectedVariable [

	^ self selectedVariable isNotNil
]

{ #category : 'layout' }
PulsarClassOutlineSideView >> horizontalLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 360;
		add: (SpPanedLayout newHorizontal 
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

{ #category : 'testing' }
PulsarClassOutlineSideView >> includesModel: aModel [

	^ listPresenter items includes: aModel
]

{ #category : 'testing' }
PulsarClassOutlineSideView >> includesModelSuchAs: aBlock [

	^ listPresenter items anySatisfy: aBlock 
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> initialize [

	super initialize.
	previewPopoverActive := false.
	updating := false
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> initializeMethods [

	listToolbarPresenter := self instantiate: PulsarToolbarPresenter.
	listToolbarPresenter actions:  (self actions actionsFor: #method).

	listPresenter := self newFilteringList 
		addStyle: 'stList';
		addStyle: 'pulsarMethodList';
		rowPresenterClass: PulsarMethodRow;
		display: [ :aModel | aModel name ];
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: (SpActionGroup new 
			add: (self actions actionsForAll: #(method methodCritical));
			addDynamicGroup: #dynamic with: [ :group | group add: self refactorActions ];
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
PulsarClassOutlineSideView >> initializePresenters [

	self initializeVariables.
	self initializeProtocols.
	self initializeMethods
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> initializeProtocols [

	protocolToolbarPresenter := self instantiate: PulsarToolbarPresenter.
	protocolToolbarPresenter actions: (self actions actionsFor: #protocol).

	protocolListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'pulsarProtocolList';
		beMultipleSelection;
		rowPresenterClass: PulsarProtocolRow;
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: (self actions actionsForAll: #(protocol protocolCritical));
		yourself
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> initializeVariables [

	variablesToolbarPresenter := self instantiate: PulsarToolbarPresenter.
	variablesToolbarPresenter actions: (self actions actionsFor: #variable).

	variablesListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'pulsarVariablesList';
		beMultipleSelection;
		rowPresenterClass: PulsarSlotRow;
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: (SpActionGroup new 
			add: (self actions actionsForAll: #(variable variableCritical));
			addDynamicGroup: #dynamic with: [ :group | group add: self variableRefactorActions ];
			yourself);
		yourself
]

{ #category : 'private - preview' }
PulsarClassOutlineSideView >> isPreviewPopoverActive [

	^ previewPopoverActive
]

{ #category : 'private - accessing' }
PulsarClassOutlineSideView >> listPresenter [

	^ listPresenter
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> listToolbarActions [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Add';
			iconName: #add;
			description: 'Add a new method';
			action: [ self doRequestNewMethod ] ]
]

{ #category : 'private - preview' }
PulsarClassOutlineSideView >> maybePopupPreview [

	| active |
	active := self isPreviewPopoverActive.
	logger trace: active.

	active ifFalse: [ ^ self ].
	self owner queueTask: [ self popupPreview ]
]

{ #category : 'private' }
PulsarClassOutlineSideView >> methodsForProtocol: aProtocolModel [

	self subclassResponsibility
]

{ #category : 'private' }
PulsarClassOutlineSideView >> methodsForVariable: aVariableModel [

	self subclassResponsibility
]

{ #category : 'private' }
PulsarClassOutlineSideView >> newMethodModelForNewMethod [

	self subclassResponsibility
]

{ #category : 'private - announcing' }
PulsarClassOutlineSideView >> notifyEntityRemoved: anEntity [

	self owner notifyEntityRemoved: anEntity
]

{ #category : 'private - preview' }
PulsarClassOutlineSideView >> popupPreview [
	| selectedModel editorPresenter |
	
	logger trace.

	previewPopover ifNotNil: [ self dismissPreview ].

	selectedModel := listPresenter selectedItem.
	selectedModel ifNil: [ ^ self ].
	
	previewPopover := self newPopover.
	
	"is important to instantiate the popover as a child of the popover"
	editorPresenter := (previewPopover 
			instantiate: PulsarMethodEditor 
			on: selectedModel)
		addStyle: 'pulsarPreviewEditor';
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
PulsarClassOutlineSideView >> refactorActions [

	self hasSelectedMethod ifFalse: [ ^ SpActionGroup new ].

	^ self selectedMethod actionsWithContextOn: self
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> resetInteractionStatus [

	previewPopoverActive := false.
	"in case it was active"
	self dismissPreview
]

{ #category : 'private' }
PulsarClassOutlineSideView >> schedule: aBlock [

	self owner schedule: aBlock
]

{ #category : 'private - accessing' }
PulsarClassOutlineSideView >> selectedMethod [

	^ listPresenter selectedItem
]

{ #category : 'private - accessing' }
PulsarClassOutlineSideView >> selectedMethodName [

	^ self selectedMethod 
		ifNotNil: [ :aModel | aModel name ]
		ifNil: [ 'Unknown' ]
]

{ #category : 'private - accessing' }
PulsarClassOutlineSideView >> selectedVariable [

	^ variablesListPresenter selectedItem
]

{ #category : 'private' }
PulsarClassOutlineSideView >> sortProtocols: aCollection [

	^ aCollection sorted:
		#order ascending,
		#isVirtual descending,
		#isExtension ascending,
		#isPrivate ascending,
		#name ascending
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> updateMethods [
	
	self updateMethodsForce: false
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> updateMethodsForce: forceBoolean [
	| items |
	
	(updating and: [ forceBoolean not ]) ifTrue: [ ^ self ].

	logger trace.

	items := activeProtocols 
		flatCollect: [ :each | self methodsForProtocol: each ]
		as: OrderedCollection.	
	activeVariables ifNotEmpty: [
		items := items select: [ :each | each isUsingAnyVariable: activeVariables ] ].
	listPresenter updateItemsKeepingSelection: items
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> updatePresenter [ 

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
PulsarClassOutlineSideView >> updateProtocols [

	logger trace.
	
	protocolListPresenter updateItemsKeepingSelection: (self sortProtocols: self collectProtocols).
	protocolListPresenter selectedItems
		ifEmpty: [ protocolListPresenter selectFirst ].
	activeProtocols := protocolListPresenter selectedItems
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> updateVariables [

	logger trace. 

	variablesListPresenter updateItemsKeepingSelection: self collectVariables.
	variablesListPresenter selectedItems
		ifEmpty: [ variablesListPresenter selectFirst ].
	activeVariables := variablesListPresenter selectedItems
]

{ #category : 'private - updating' }
PulsarClassOutlineSideView >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : 'layout' }
PulsarClassOutlineSideView >> useHorizontalLayout [

	usingLayout = #horizontal ifTrue: [ ^ self ].
	
	usingLayout := #horizontal.
	self layout: self horizontalLayout
]

{ #category : 'layout' }
PulsarClassOutlineSideView >> useVerticalLayout [

	usingLayout = #vertical ifTrue: [ ^ self ].
	
	usingLayout := #vertical.
	self layout: self verticalLayout
]

{ #category : 'initialization' }
PulsarClassOutlineSideView >> variableRefactorActions [

	self hasSelectedVariable ifFalse: [ ^ SpActionGroup new ].

	^ self selectedVariable actionsWithContextOn: self
]

{ #category : 'layout' }
PulsarClassOutlineSideView >> verticalLayout [

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

{ #category : 'visiting' }
PulsarClassOutlineSideView >> visitClassModel: aModel [

	listPresenter unselectAll.
	variablesListPresenter unselectAll
]

{ #category : 'visiting' }
PulsarClassOutlineSideView >> visitMethodModel: aModel [
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
