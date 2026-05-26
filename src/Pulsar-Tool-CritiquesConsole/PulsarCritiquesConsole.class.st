"
A console to show critics in code. 
the console filters critics by method (the default), class and package.

"
Class {
	#name : 'PulsarCritiquesConsole',
	#superclass : 'PulsarBaseView',
	#instVars : [
		'#toolbarPresenter',
		'#listPresenter',
		'#lastIncomingModel => WeakSlot'
	],
	#category : 'Pulsar-Tool-CritiquesConsole',
	#package : 'Pulsar-Tool-CritiquesConsole'
}

{ #category : 'defaults' }
PulsarCritiquesConsole class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
		column: 2;
		yourself
]

{ #category : 'accessing' }
PulsarCritiquesConsole class >> defaultTitle [

	^ 'Critiques'
]

{ #category : 'private' }
PulsarCritiquesConsole >> checkIncomingModel: aModel [

	lastIncomingModel = aModel ifTrue: [ ^ self ].
	lastIncomingModel := aModel.

	(self model updateWith: aModel)
		ifTrue: [ self updatePresenter ]
]

{ #category : 'private' }
PulsarCritiquesConsole >> checkIncomingModel: aModel forceUpdate: forceBoolean [ 

	((lastIncomingModel = aModel) and: [ forceBoolean not ]) ifTrue: [ ^ self ].
	lastIncomingModel := aModel.

	((self model updateWith: aModel) or: [ forceBoolean ])
		ifTrue: [ self updatePresenter ]
]

{ #category : 'initialization' }
PulsarCritiquesConsole >> connectPresenters [

	listPresenter outputActivationPort
		transmitDo: [ :aCritic | self entityActivated: aCritic ]
]

{ #category : 'api - focus' }
PulsarCritiquesConsole >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
PulsarCritiquesConsole >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - actions' }
PulsarCritiquesConsole >> doActivateClassScope [

	self model: (PulsarClassCritiquesModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
PulsarCritiquesConsole >> doActivateMethodScope [

	self model: (PulsarMethodCritiquesModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
PulsarCritiquesConsole >> doActivatePackageScope [

	self model: (PulsarPackageCritiquesModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
PulsarCritiquesConsole >> doClose [

	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - events' }
PulsarCritiquesConsole >> entityActivated: anEntity [

	self notificationCenter announce: (self model newActivationAnnouncementFor: anEntity)
]

{ #category : 'events' }
PulsarCritiquesConsole >> eventEditorActivated: ann [
	| editorModel |
	
	editorModel := ann value model.
	editorModel includesClassModel ifFalse: [ ^ self ].
	
	self 
		checkIncomingModel: editorModel
		forceUpdate: false
]

{ #category : 'events' }
PulsarCritiquesConsole >> eventMethodChanged: aMethodAnnouncement [
	| method methodModel |

	method := aMethodAnnouncement method.
	methodModel := PvMethodModel 
		newEnvironment: self model environmentModel
		entity: method.
	
	methodModel = lastIncomingModel
		ifTrue: [ self checkIncomingModel: methodModel forceUpdate: true ]
]

{ #category : 'initialization' }
PulsarCritiquesConsole >> initializePresenters [


	self initializeToolbar.
	"listPresenter := self newEasyColumnView
		addStyle: 'stList';
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :aCritique | aCritique rule ruleName ]);
		addColumn: (SpStringTableColumn title: 'Message' evaluated: [ :aCritique | aCritique tinyHint ]);
		yourself"
	listPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :aCritique | aCritique rule ruleName ];
		yourself
]

{ #category : 'initialization' }
PulsarCritiquesConsole >> initializeToolbar [
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
	
	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
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
PulsarCritiquesConsole >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: self panelPlacedIconName)
]

{ #category : 'instance creation' }
PulsarCritiquesConsole >> newMethodModelFor: aMethod [

	^ PvMethodModel
		newEnvironment: self environmentModel
		entity: aMethod
]

{ #category : 'private' }
PulsarCritiquesConsole >> panelPlacedIconName [

	^ 'critiques'
]

{ #category : 'initialization' }
PulsarCritiquesConsole >> registerToEvents [

	super registerToEvents.
	self announcer
		"when: PulsarModelActivated send: #eventModelActivated: to: self;"
		when: PulsarEditorActivated send: #eventEditorActivated: to: self
]

{ #category : 'initialization' }
PulsarCritiquesConsole >> registerToSystemEvents [
	
	self announcer
		when: MethodAnnouncement send: #eventMethodChanged: to: self
]

{ #category : 'initialization' }
PulsarCritiquesConsole >> updatePresenter [

	self model ifNil: [ ^ self ].

	self window scheduleTask: [
		| critiques |
		"first calculate outside (in the task)"
		critiques := self model critiques. 
		"now call the ui thread with the data already there"
		self application defer: [
			toolbarPresenter title: self model title.
			listPresenter items: critiques ] ]
]

{ #category : 'private' }
PulsarCritiquesConsole >> updateWithLastIncomingModel [

	(self model updateWith: lastIncomingModel)
		ifTrue: [ self updatePresenter ]
]
