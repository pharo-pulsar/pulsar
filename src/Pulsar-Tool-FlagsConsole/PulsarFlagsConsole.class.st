"
A console to show flags in code. 
the console filters flags by package (the default) and class.

"
Class {
	#name : 'PulsarFlagsConsole',
	#superclass : 'PulsarBaseView',
	#instVars : [
		'#toolbarPresenter',
		'#listPresenter',
		'#lastIncomingModel => WeakSlot'
	],
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'defaults' }
PulsarFlagsConsole class >> defaultPanelPosition [

	^ SpPanelPosition bottomArea
]

{ #category : 'accessing' }
PulsarFlagsConsole class >> defaultTitle [

	^ 'Flags'
]

{ #category : 'private' }
PulsarFlagsConsole >> checkIncomingModel: aModel [

	lastIncomingModel = aModel ifTrue: [ ^ self ].
	lastIncomingModel := aModel.

	(self model updateWith: aModel)
		ifTrue: [ self updatePresenter ]
]

{ #category : 'private' }
PulsarFlagsConsole >> checkIncomingModel: aModel forceUpdate: forceBoolean [ 

	lastIncomingModel = aModel ifTrue: [ ^ self ].
	lastIncomingModel := aModel.

	((self model updateWith: aModel) or: [ forceBoolean ])
		ifTrue: [
			self model reset.
			self updatePresenter ]
]

{ #category : 'initialization' }
PulsarFlagsConsole >> connectPresenters [

	listPresenter outputActivationPort
		transmitDo: [ :aFlag | self entityActivated: aFlag ]
]

{ #category : 'api - focus' }
PulsarFlagsConsole >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
PulsarFlagsConsole >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - actions' }
PulsarFlagsConsole >> doActivateClassScope [

	self model: (PulsarClassFlagsModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
PulsarFlagsConsole >> doActivatePackageScope [

	self model: (PulsarPackageFlagsModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
PulsarFlagsConsole >> doClose [

	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'private - events' }
PulsarFlagsConsole >> entityActivated: anEntity [

	self notificationCenter announce: (self model newActivationAnnouncementFor: anEntity)
]

{ #category : 'events' }
PulsarFlagsConsole >> eventEditorActivated: ann [

	self 
		checkIncomingModel: ann value model
		forceUpdate: false
]

{ #category : 'events' }
PulsarFlagsConsole >> eventMethodChanged: aMethodAnnouncement [
	| methodModel |

	methodModel := self model newMethodModelFor: aMethodAnnouncement method.
	
	"reset to force updating... maybe not the best way?"
	lastIncomingModel = methodModel 
		ifTrue: [ lastIncomingModel := nil ].
	self checkIncomingModel: methodModel forceUpdate: true
]

{ #category : 'initialization' }
PulsarFlagsConsole >> initialize [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents
]

{ #category : 'initialization' }
PulsarFlagsConsole >> initializePresenters [


	self initializeToolbar.
	listPresenter := self newEasyColumnView
		addStyle: 'stList';
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Place' evaluated: [ :each | self model locationDescriptionFor: each ]);
		addColumn: (SpStringTableColumn title: 'Message' evaluated: #message);
		yourself
]

{ #category : 'initialization' }
PulsarFlagsConsole >> initializeToolbar [
	| scopeClassButton scopePackageButton |
	
	scopeClassButton := self newToggleButton
		addStyle: 'flat';
		icon: (self iconNamed: #class);
		help: 'Toggle class scope';
		state: (self model isScope: #class);
		whenActivatedDo: [ self doActivateClassScope ];
		yourself.
	scopePackageButton := self newToggleButton
		addStyle: 'flat';
		icon: (self iconNamed: #package);
		help: 'Toggle package scope';
		state: (self model isScope: #package);
		whenActivatedDo: [ self doActivatePackageScope ];
		yourself.
		
	scopeClassButton associatedToggleButtons: { scopePackageButton }.
	
	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter addPresenter: (self newToolbar
		displayMode: self application toolbarDisplayMode;
		add: scopeClassButton;
		add: scopePackageButton;
		yourself).
	toolbarPresenter addPresenter: (self newToolbar 
		beIcons; 
		add: (self newButton
			addStyle: 'flat';
			icon: (self iconNamed: 'close');
			help: 'Close flags console';
			action: [ self doClose ];
			yourself);
		yourself)
]

{ #category : 'initialization' }
PulsarFlagsConsole >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: self panelPlacedIconName)
]

{ #category : 'private' }
PulsarFlagsConsole >> panelPlacedIconName [

	^ 'flag'
]

{ #category : 'initialization' }
PulsarFlagsConsole >> registerToEvents [

	self announcer
		when: PulsarEditorActivated 
		send: #eventEditorActivated: 
		to: self
]

{ #category : 'initialization' }
PulsarFlagsConsole >> registerToSystemEvents [
	
	self announcer
		when: MethodAnnouncement 
		send: #eventMethodChanged: 
		to: self
]

{ #category : 'initialization' }
PulsarFlagsConsole >> updatePresenter [

	self model ifNil: [ ^ self ].

	self application scheduleTask: [
		| flags |
		"first calculate outside (in the task)"
		flags := self model flags. 
		"now call the ui thread with the data already there"
		self application defer: [
			toolbarPresenter title: self model title.
			listPresenter items: flags ] ]
]

{ #category : 'private' }
PulsarFlagsConsole >> updateWithLastIncomingModel [

	(self model updateWith: lastIncomingModel)
		ifTrue: [ self updatePresenter ]
]
