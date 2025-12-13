Class {
	#name : 'DockFlagsConsole',
	#superclass : 'DockBaseView',
	#instVars : [
		'#toolbarPresenter',
		'#listPresenter',
		'#lastIncomingModel => WeakSlot'
	],
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'defaults' }
DockFlagsConsole class >> defaultDockPosition [

	^ SpPanelPosition new 
		area: SpPanelArea bottom;
		yourself
]

{ #category : 'accessing' }
DockFlagsConsole class >> defaultTitle [

	^ 'Flags'
]

{ #category : 'initialization' }
DockFlagsConsole >> connectPresenters [

	listPresenter outputActivationPort
		transmitDo: [ :aFlag | self entityActivated: aFlag ]
]

{ #category : 'api - focus' }
DockFlagsConsole >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
DockFlagsConsole >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - actions' }
DockFlagsConsole >> doActivateClassScope [

	self model: (DockClassFlagsModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
DockFlagsConsole >> doActivatePackageScope [

	self model: (DockPackageFlagsModel newEnvironment: self model environmentModel).
	self updateWithLastIncomingModel
]

{ #category : 'private - actions' }
DockFlagsConsole >> doClose [

	self withPanelWindowDo: #close
]

{ #category : 'private - events' }
DockFlagsConsole >> entityActivated: anEntity [

	self notificationCenter announce: (self model newActivationAnnouncementFor: anEntity)
]

{ #category : 'events' }
DockFlagsConsole >> eventMethodChanged: aMethodAnnouncement [
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
DockFlagsConsole >> eventModelSelected: ann [
	| incomingModel |
	
	incomingModel := ann value.
	
	lastIncomingModel = incomingModel ifTrue: [ ^ self ].
	lastIncomingModel := incomingModel.

	(self model updateWith: incomingModel)
		ifTrue: [ self updatePresenter ]
]

{ #category : 'initialization' }
DockFlagsConsole >> initialize [

	super initialize.
	self registerToEvents.
	self registerToSystemEvents
]

{ #category : 'initialization' }
DockFlagsConsole >> initializePresenters [


	self initializeToolbar.
	listPresenter := self newEasyColumnView
		addStyle: 'stList';
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Place' evaluated: [ :each | self model locationDescriptionFor: each ]);
		addColumn: (SpStringTableColumn title: 'Message' evaluated: #message);
		yourself
]

{ #category : 'initialization' }
DockFlagsConsole >> initializeToolbar [
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
	
	toolbarPresenter := self instantiate: DockEditorToolbarPresenter.
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
DockFlagsConsole >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: (self iconNamed: 'flag')
]

{ #category : 'initialization' }
DockFlagsConsole >> registerToEvents [

	self announcer
		when: DockModelSelected
		send: #eventModelSelected:
		to: self
]

{ #category : 'initialization' }
DockFlagsConsole >> registerToSystemEvents [
	
	self announcer
		when: MethodAnnouncement send: #eventMethodChanged: to: self
]

{ #category : 'initialization' }
DockFlagsConsole >> updatePresenter [

	self model ifNil: [ ^ self ].

	self application schedule: [ 
		| flags |
		"first calculate outside (in the task)"
		flags := self model flags.
		"now call the ui thread with the data already there"
		self application defer: [
			toolbarPresenter title: self model title.
			listPresenter items: flags ] ]
]

{ #category : 'private' }
DockFlagsConsole >> updateWithLastIncomingModel [

	(self model updateWith: lastIncomingModel)
		ifTrue: [ self updatePresenter ]
]
