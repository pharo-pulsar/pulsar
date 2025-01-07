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

{ #category : 'as yet unclassified' }
DockClassOutlineSideView class >> defineActionGroupCritical: actionGroup [
	<perspectiveActionGroup: #criticalActions>
	
	actionGroup 
		name: 'DANGER';
		priority: 1000;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineActionGroupNew: actionGroup [
	<perspectiveActionGroup: #methodActions>
	
	actionGroup 
		name: 'Method';
		priority: 10;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockClassOutlineSideView class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #methodActions with: { 
			DockNewMethodCommand new.
		};
		registerGroup: #criticalActions with: {
			$x mod1 shift -> DockRemoveMethodCommand new.
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
DockClassOutlineSideView >> doAddProtocol [

	self halt
]

{ #category : 'private - actions' }
DockClassOutlineSideView >> doAddVariable [

	self halt
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
DockClassOutlineSideView >> initializePresenters [

	variablesToolbarPresenter := self instantiate: DockToolbarPresenter.
	variablesToolbarPresenter actions: self variablesToolbarActions.

	variablesListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockVariablesList';
		display: [ :aModel | aModel name ];
		yourself.

	protocolToolbarPresenter := self instantiate: DockToolbarPresenter.
	protocolToolbarPresenter actions: self protocolToolbarActions.

	protocolListPresenter := self newEasyListView
		addStyle: 'stList';
		addStyle: 'dockProtocolList';
		rowPresenterClass: DockProtocolRow;
		yourself.

	listToolbarPresenter := self instantiate: DockToolbarPresenter.
	listToolbarPresenter actions:  (self actions actionsFor: #methodActions).

	listPresenter := self newEasyListView 
		addStyle: 'stList';
		addStyle: 'dockMethodList';
		display: [ :aModel | aModel name ];
		searchMatching: [ :aModel :aString | 
			aModel name asLowercase beginsWith: aString asLowercase ];
		actions: self actions;
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
DockClassOutlineSideView >> protocolToolbarActions [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Add';
			description: 'Add a new protocol';
			iconName: #add;
			action: [ self doAddProtocol ] ]
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updateMethods [
	| items |

	updating ifTrue: [ ^ self ].

	items := self methodsForProtocol: activeProtocol.	
	activeVariable ifNotNil: [ 
		items := items select: [ :each | each isUsingVariable: activeVariable ] ].
	listPresenter items: items.
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updatePresenter [ 

	self model ifNil: [ ^ self ].
	
	"I defer to make the update happen at one in UI thread (it looks smoother)"
	self application defer: [
		"prevent update methods until is its time"
		self updatingWhile: [ 	
			variablesListPresenter 
				items: self collectVariables;
				selectFirst.
			activeVariable := variablesListPresenter selectedItem.
			self updateProtocols.
			activeProtocol := protocolListPresenter selectedItem ].
		"update methods happens outside the updating flag... :P"
		self updateMethods ]
]

{ #category : 'initialization' }
DockClassOutlineSideView >> updateProtocols [

	protocolListPresenter 
		items: self collectProtocols;
		"this is because I know the first is 'all', but I may need to 
		 do a better job on this..."
		selectFirst
]

{ #category : 'private - updating' }
DockClassOutlineSideView >> updatingWhile: aBlock [ 
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	^ aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : 'initialization' }
DockClassOutlineSideView >> variablesToolbarActions [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Add';
			description: 'Add a new variable';
			iconName: #add;
			action: [ self doAddVariable ] ]
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
		ifFalse: [ self updateProtocols ].
	
	listPresenter
		selectItem: aModel
		scrollToSelection: true
]
