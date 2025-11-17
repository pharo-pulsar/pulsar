Class {
	#name : 'DockApplication',
	#superclass : 'StPharoApplication',
	#traits : 'SgaTApplication + DockTScheduling',
	#classTraits : 'SgaTApplication classTrait + DockTScheduling classTrait',
	#instVars : [
		'name',
		'standalone'
	],
	#classInstVars : [
		'lastSnapshot',
		'running'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'activation' }
DockApplication class >> applicationName [

	^ 'dock'
]

{ #category : 'accessing' }
DockApplication class >> defaultBackendName [

	^ #Gtk
]

{ #category : 'class initialization' }
DockApplication class >> initialize [
	
	SessionManager default registerGuiClassNamed: self name
]

{ #category : 'accessing' }
DockApplication class >> lastSnapshot [

	^ lastSnapshot
]

{ #category : 'accessing' }
DockApplication class >> lastSnapshot: aSnapshot [

	lastSnapshot := aSnapshot
]

{ #category : 'private' }
DockApplication class >> reset [
	<script>
	
	DockUIManager reset.
	OupsDebuggerSelectionStrategy debuggerSelectionStrategy: nil. 
	"yes, there are better ways to do this, for for now..."
	DockWorker allInstances do: #stop.
	Transcript dependents copy
		collect: [ :each | each isKindOf: DockTranscript ]
		thenDo: [ :each | Transcript removeDependent: each ].
	running := nil
]

{ #category : 'private' }
DockApplication class >> resetLastSnapshot [
	<script>

	lastSnapshot := nil
]

{ #category : 'accessing' }
DockApplication class >> running [

	^ running
]

{ #category : 'accessing' }
DockApplication class >> running: anApplication [

	running := anApplication
]

{ #category : 'system startup' }
DockApplication class >> shutDown: quitting [

	self running ifNotNil: [ :anApplication | 
		anApplication shutDown: quitting ].
	quitting ifFalse: [ ^ self ].
	self reset
]

{ #category : 'system startup' }
DockApplication class >> startUp: resuming [

	resuming ifFalse: [ ^ self ].
	self reset
]

{ #category : 'private' }
DockApplication >> checkForLostChanges [
	| lostChangesDetector |


	lostChangesDetector := EpLostChangesDetector new.
	lostChangesDetector hasLostChanges ifFalse: [ ^ self ].
	
	self schedule: [
		self resendAnnouncement: (DockLostChangesAnnouncement new 
			detector: lostChangesDetector;
			yourself) ]
]

{ #category : 'initialization' }
DockApplication >> cleanUp [

	"weird things can happen when exiting the image in an unconventional way...  
	 e.g. close the last window will not save the registry clean up hence letting a dockapplication 
	 registered. We need to ensure this will be correct not just because of the leak, but also 
	 beacuse if announcements go to dead browsers the system will crash." 
	(self class codeChangeAnnouncer subscriptions subscriptions 
		select: [ :each | each subscriber class = DockApplication ])
		do: [ :each | self class codeChangeAnnouncer subscriptions removeSubscriber: each subscriber ].
		
	"also clean processes that may have remained"
	(Processor allProcesses 
		select: [ :each | each name beginsWith: self className ])
		do: [ :each | each terminate ]
]

{ #category : 'settings' }
DockApplication >> colorForTestResultAt: aStatus [
	"aStatus is 'Passed', 'Failed' or 'Error'"

	^ self colorsForTestResult at: aStatus
]

{ #category : 'accessing' }
DockApplication >> colorNamed: aString [

	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : 'settings' }
DockApplication >> colorsForTestResult [

	^ self configuration colorsForTestResult
]

{ #category : 'accessing' }
DockApplication >> dockBrowser [
	"for now the application will have just one Dock active (it can have a lot more windows, but more than 
	 one dock feels very disturbing)"
	 
	 ^ self windows 
	 	detect: [ :each | each class = DockBrowser ]
	 	ifNone: [ nil ]
]

{ #category : 'finalization' }
DockApplication >> finalize [

	self class codeChangeAnnouncer unsubscribe: self
]

{ #category : 'accessing' }
DockApplication >> iconCache [

	^ self 
		propertyAt: #iconCache 
		ifAbsentPut: [ PvCompositeIconCache new ]
]

{ #category : 'ui - requests' }
DockApplication >> inform: aString [

	aString printToStdout
]

{ #category : 'initialization' }
DockApplication >> initialize [

	super initialize.
	FinalizationRegistry default add: self.
	self registerToSystemEvents
]

{ #category : 'initialization' }
DockApplication >> initializeConfiguration [

	self resetConfiguration.
	self 
		useBackend: #Gtk 
		with: self newConfiguration
]

{ #category : 'settings' }
DockApplication >> isShowingLineNumbers [

	^ true
]

{ #category : 'testing' }
DockApplication >> isStandalone [

	^ standalone == true
]

{ #category : 'initialization' }
DockApplication >> newConfiguration [

	^ DockGtkConfiguration new
		applicationId: 'org.pharo.Dock';
		applicationClass: PanelApplication;
		yourself
]

{ #category : 'ui - dialogs' }
DockApplication >> newConfirm [

	^ (DockConfirmDialog newApplication: self)
		parentWindow: self topWindow;
		yourself
]

{ #category : 'private - factory' }
DockApplication >> newIconProvider [

	^ (PvAliasedVSCodeIconProvider new
			application: self;
			addLocation: self resourcesDir / 'vscode-extraicons';
			addLocation: self resourcesDir / 'vscode-codicons';
			addLocation: self resourcesDir / 'vscode-icons';
			yourself),
	  PvDefaultIconProvider new
]

{ #category : 'ui - dialogs' }
DockApplication >> newInform [

	^ (DockInformDialog newApplication: self)
		parentWindow: self topWindow;
		yourself
]

{ #category : 'ui - dialogs' }
DockApplication >> newRequest [

	^ (DockRequestDialog newApplication: self) 
		parentWindow: self topWindow;
		yourself
]

{ #category : 'private - scheduling' }
DockApplication >> newScheduler [ 

	^ TKTWorkerPool new
		name: self className;
		poolMaxSize: 5;
		start
]

{ #category : 'ui - dialogs' }
DockApplication >> newSelect [

	^ (DockSelectDialog newApplication: self)
		parentWindow: self topWindow;
		yourself
]

{ #category : 'private - factory' }
DockApplication >> newSettings [

	^ PvActionSettings new
		"this can change by platform (linux, mac or windows)"
		mod1: Smalltalk os mod1;
		mod2: Smalltalk os mod2;
		mod3: Smalltalk os mod3;
		yourself
]

{ #category : 'private - factory' }
DockApplication >> newSystemTools [

	^ Smalltalk tools deepCopy
		register: StMessageBrowser as: #messageList;
		yourself
]

{ #category : 'initialization' }
DockApplication >> prepareAsStandaloneApplication [
	
	standalone := true.
	self cleanUp.
	self killUnusedProcesses.
	self prepareSchedulerAsStandaloneApplication.
	self prepareErrorHandlerAsStandaloneApplication
]

{ #category : 'initialization' }
DockApplication >> prepareErrorHandlerAsStandaloneApplication [

	DockUIManager activateOn: self.
	ErrorHandler default: InteractiveErrorHandler new.
	OupsDebuggerSelectionStrategy debuggerSelectionStrategy: (DockSingleDebuggerSelector on: self)
]

{ #category : 'initialization' }
DockApplication >> registerToSystemEvents [

	"this way I have just one subscription for each application, that will be broadcasted to 
	 all applications windows"
	self class codeChangeAnnouncer weak
		when: SystemAnnouncement 
		send: #resendAnnouncement: 
		to: self
]

{ #category : 'initialization' }
DockApplication >> reloadConfiguration [

	^ self configuration reloadOnApplication: self
]

{ #category : 'announcing' }
DockApplication >> resendAnnouncement: anAnnouncement [
	
	self windows do: [ :aWindowPresenter |
		aWindowPresenter announce: anAnnouncement ]
]

{ #category : 'private - factory' }
DockApplication >> resourcesDir [
	
	^ IceRepository registry 
		detect: [ :each | each name = 'DockBrowser' ]
		ifFound: [ :aRepository | aRepository location / 'resources' ]
		ifNone: [ FileLocator imageDirectory / 'resources' ].
]

{ #category : 'running' }
DockApplication >> run [

	self class running ifNotNil: [ :anApplication | 
		anApplication shutDown: false ].
	self start.
	self class running: self
]

{ #category : 'accessing' }
DockApplication >> settings [

	^ self 
		propertyAt: #settings
		ifAbsentPut: [ DockSettings new ]
]

{ #category : 'system startup' }
DockApplication >> shutDown: quitting [

	"Shutingdown is a very critical process and any failure may let the system in a very 
	 inconsistent status. We need to be sure this will not fail."
	logger trace.
	[ 
		self takeSnapshot.
	 	logger info: 'Snapshot taken' ]
	on: Error 
	do: [ :e |
		logger error: e.
		e messageText printToStdout ]
]

{ #category : 'accessing' }
DockApplication >> snapshot [

	^ DockApplicationSnapshot on: self
]

{ #category : 'running' }
DockApplication >> start [
	| snapshot browser |

	snapshot := self class lastSnapshot.
	(snapshot isNotNil and: [ snapshot hasRecords ]) 
		ifTrue: [ snapshot restoreTo: self ]
		ifFalse: [ (DockBrowser newApplication: self) open ].
		
	self schedule: [ self checkForLostChanges ]
]

{ #category : 'settings' }
DockApplication >> subscribeToSettingsAnnouncements [
	"do nothing, this thing will not work with morphic"
]

{ #category : 'private - events' }
DockApplication >> syntaxHighlightThemeChanged: ann [

	self propertyAt: #syntaxHighlightTheme put: ann newTheme.
	self resendAnnouncement: ann
]

{ #category : 'accessing' }
DockApplication >> systemNavigation [

	^ DockSystemNavigation new
]

{ #category : 'accessing' }
DockApplication >> takeSnapshot [

	"do not take the snapshot if there is no windows, because like that I can keep 
	 the last one"
	self windows size > 0 ifFalse: [ ^ self ].
	self class lastSnapshot: self snapshot
]

{ #category : 'settings' }
DockApplication >> toolbarDisplayMode [

	^ SpToolbarDisplayMode modeIcon
]

{ #category : 'initialization' }
DockApplication >> useGtkDark [

	self 
		useBackend: #Gtk 
		with: self newConfiguration forceDark
]

{ #category : 'initialization' }
DockApplication >> useGtkLight [

	self 
		useBackend: #Gtk 
		with: self newConfiguration forceLight
]

{ #category : 'accessing' }
DockApplication >> windowWillClose: aWindow [
	
	"I'm keeping a snapshot of last open window :)"
	self windows size > 1 ifTrue: [ ^ self ].
	self takeSnapshot
]
