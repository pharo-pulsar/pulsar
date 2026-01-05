"
A console to show critics in code. 
the console filters critics by method (the default), class and package.

"
Class {
	#name : 'DockCritiquesConsole',
	#superclass : 'DockBaseView',
	#traits : 'DockTPanelWindowWithPlacedIcon',
	#classTraits : 'DockTPanelWindowWithPlacedIcon classTrait',
	#instVars : [
		'toolbarPresenter',
		'listPresenter',
		'lastIncomingModel'
	],
	#category : 'Dock-Tool-CriticsConsole',
	#package : 'Dock-Tool-CriticsConsole'
}

{ #category : 'defaults' }
DockCritiquesConsole class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea bottom;
		yourself
]

{ #category : 'accessing' }
DockCritiquesConsole class >> defaultTitle [

	^ 'Critiques'
]

{ #category : 'initialization' }
DockCritiquesConsole >> connectPresenters [

	listPresenter outputActivationPort
		transmitDo: [ :aCritic | self entityActivated: aCritic ]
]

{ #category : 'api - focus' }
DockCritiquesConsole >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
DockCritiquesConsole >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - actions' }
DockCritiquesConsole >> doActivateClassScope [

	self model: (DockClassCritiquesModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
DockCritiquesConsole >> doActivateMethodScope [

	self model: (DockMethodCritiquesModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
DockCritiquesConsole >> doActivatePackageScope [

	self model: (DockPackageCritiquesModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
DockCritiquesConsole >> doClose [

	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - events' }
DockCritiquesConsole >> entityActivated: anEntity [

	self notificationCenter announce: (self model newActivationAnnouncementFor: anEntity)
]

{ #category : 'events' }
DockCritiquesConsole >> eventMethodChanged: aMethodAnnouncement [
	| method methodModel |

	method := aMethodAnnouncement method.
	methodModel := PvMethodModel 
		newEnvironment: self model environmentModel
		entity: method.
	
	self model reset.
	self model updateWith: methodModel.
	self updatePresenter
]

{ #category : 'events' }
DockCritiquesConsole >> eventModelSelected: ann [
	| incomingModel |
	
	incomingModel := ann value.
	
	lastIncomingModel = incomingModel ifTrue: [ ^ self ].
	lastIncomingModel := incomingModel.

	(self model updateWith: incomingModel)
		ifTrue: [ self updatePresenter ]
]

{ #category : 'initialization' }
DockCritiquesConsole >> initialize [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents
]

{ #category : 'initialization' }
DockCritiquesConsole >> initializePanelWindow: aWindowPresenter [

	super initializePanelWindow: aWindowPresenter.
	aWindowPresenter 
		whenPlacedDo: [ self panelPlaced: aWindowPresenter ]
]

{ #category : 'initialization' }
DockCritiquesConsole >> initializePresenters [


	self initializeToolbar.
	listPresenter := self newEasyColumnView
		addStyle: 'stList';
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :aCritique | aCritique rule ruleName ]);
		addColumn: (SpStringTableColumn title: 'Message' evaluated: [ :aCritique | aCritique tinyHint ]);
		yourself
]

{ #category : 'initialization' }
DockCritiquesConsole >> initializeToolbar [
	| scopeMethodButton scopeClassButton |
	
	"scopeMethodButton := self newToggleButton
		addStyle: 'flat';
		icon: (self iconNamed: #method);
		help: 'Toggle method scope';
		state: (self model isScope: #method);
		whenActivatedDo: [ self doActivateMethodScope ];
		yourself.
	scopeClassButton := self newToggleButton
		addStyle: 'flat';
		icon: (self iconNamed: #class);
		help: 'Toggle class scope';
		state: (self model isScope: #class);
		whenActivatedDo: [ self doActivateClassScope ];
		yourself.
		
	scopeMethodButton associatedToggleButtons: { scopeClassButton }."
	
	toolbarPresenter := self instantiate: DockEditorToolbarPresenter.
	"toolbarPresenter addPresenter: (self newToolbar
		displayMode: self application toolbarDisplayMode;
		add: scopeMethodButton;
		add: scopeClassButton;
		add: scopePackageButton;
		yourself)."
	toolbarPresenter addPresenter: (self newToolbar 
		beIcons; 
		add: (self newButton
			addStyle: 'flat';
			icon: (self iconNamed: 'close');
			help: 'Close critics console';
			action: [ self doClose ];
			yourself);
		yourself)
]

{ #category : 'initialization' }
DockCritiquesConsole >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: self panelPlacedIconName)
]

{ #category : 'private' }
DockCritiquesConsole >> panelPlacedIconName [

	^ 'critics'
]

{ #category : 'initialization' }
DockCritiquesConsole >> registerToEvents [

	self announcer
		when: DockModelSelected
		send: #eventModelSelected:
		to: self
]

{ #category : 'initialization' }
DockCritiquesConsole >> registerToSystemEvents [
	
	self announcer
		when: MethodAnnouncement send: #eventMethodChanged: to: self
]

{ #category : 'initialization' }
DockCritiquesConsole >> updatePresenter [

	self model ifNil: [ ^ self ].

	self application schedule: [ 
		| critiques |
		"first calculate outside (in the task)"
		critiques := self model critiques.
		"now call the ui thread with the data already there"
		self application defer: [
			toolbarPresenter title: self model title.
			listPresenter items: critiques ] ]
]

{ #category : 'private' }
DockCritiquesConsole >> updateWithLastIncomingModel [

	(self model updateWith: lastIncomingModel)
		ifTrue: [ self updatePresenter ]
]
