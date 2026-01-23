"
The Pulsar application. 
Entry point of the IDE, it ensures all conditions are set before initiating session (recovering from last stapshot or creating a default environment)
"
Class {
	#name : 'PulsarApplication',
	#superclass : 'StPharoApplication',
	#traits : 'SgaTApplication',
	#classTraits : 'SgaTApplication classTrait',
	#instVars : [
		'standalone',
		'scheduler'
	],
	#classInstVars : [
		'lastSnapshot',
		'running'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'activation' }
PulsarApplication class >> applicationName [

	^ 'dock'
]

{ #category : 'accessing' }
PulsarApplication class >> defaultBackendName [

	^ #Gtk
]

{ #category : 'class initialization' }
PulsarApplication class >> initialize [
	
	SessionManager default registerGuiClassNamed: self name
]

{ #category : 'accessing' }
PulsarApplication class >> lastSnapshot [

	^ lastSnapshot
]

{ #category : 'accessing' }
PulsarApplication class >> lastSnapshot: aSnapshot [

	lastSnapshot := aSnapshot
]

{ #category : 'private' }
PulsarApplication class >> reset [
	<script>
	
	PulsarUIManager reset.
	OupsDebuggerSelectionStrategy debuggerSelectionStrategy: nil. 
	"yes, there are better ways to do this, for for now..."
	PulsarWorker allInstances do: #stop.
	Transcript dependents copy
		collect: [ :each | each isKindOf: PulsarTranscript ]
		thenDo: [ :each | Transcript removeDependent: each ].
	running := nil
]

{ #category : 'private' }
PulsarApplication class >> resetLastSnapshot [
	<script>

	lastSnapshot := nil
]

{ #category : 'accessing' }
PulsarApplication class >> running [

	^ running
]

{ #category : 'accessing' }
PulsarApplication class >> running: anApplication [

	running := anApplication
]

{ #category : 'system startup' }
PulsarApplication class >> shutDown: quitting [

	self running ifNotNil: [ :anApplication | 
		anApplication shutDown: quitting ].
	quitting ifFalse: [ ^ self ].
	self reset
]

{ #category : 'system startup' }
PulsarApplication class >> startUp: resuming [

	resuming ifFalse: [ ^ self ].
	self reset
]

{ #category : 'private' }
PulsarApplication >> checkForLostChanges [
	| lostChangesDetector |

	lostChangesDetector := EpLostChangesDetector new.
	lostChangesDetector hasLostChanges ifFalse: [ ^ self ].
	
	self scheduleTask: [
		self resendAnnouncement: (PulsarLostChangesAnnouncement new 
			detector: lostChangesDetector;
			yourself) ]
]

{ #category : 'initialization' }
PulsarApplication >> cleanUp [

	"weird things can happen when exiting the image in an unconventional way...  
	 e.g. close the last window will not save the registry clean up hence letting a dockapplication 
	 registered. We need to ensure this will be correct not just because of the leak, but also 
	 beacuse if announcements go to dead browsers the system will crash." 
	(self class codeChangeAnnouncer subscriptions subscriptions 
		select: [ :each | each subscriber class = PulsarApplication ])
		do: [ :each | self class codeChangeAnnouncer subscriptions removeSubscriber: each subscriber ].
		
	"also clean processes that may have remained"
	(Processor allProcesses 
		select: [ :each | each name beginsWith: self className ])
		do: [ :each | each terminate ]
]

{ #category : 'settings' }
PulsarApplication >> colorForTestResultAt: aStatus [
	"aStatus is 'Passed', 'Failed' or 'Error'"

	^ self colorsForTestResult at: aStatus
]

{ #category : 'accessing' }
PulsarApplication >> colorNamed: aString [

	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : 'settings' }
PulsarApplication >> colorsForTestResult [

	^ self configuration colorsForTestResult
]

{ #category : 'finalization' }
PulsarApplication >> finalize [

	self class codeChangeAnnouncer unsubscribe: self
]

{ #category : 'accessing' }
PulsarApplication >> iconCache [

	^ self 
		propertyAt: #iconCache 
		ifAbsentPut: [ PvCompositeIconCache new ]
]

{ #category : 'ui - requests' }
PulsarApplication >> inform: aString [

	aString printToStdout
]

{ #category : 'initialization' }
PulsarApplication >> initialize [

	super initialize.
	FinalizationRegistry default add: self.
	self registerToSystemEvents
]

{ #category : 'initialization' }
PulsarApplication >> initializeConfiguration [

	self resetConfiguration.
	self 
		useBackend: #Gtk 
		with: self newConfiguration
]

{ #category : 'settings' }
PulsarApplication >> isShowingLineNumbers [

	^ true
]

{ #category : 'testing' }
PulsarApplication >> isStandalone [

	^ standalone == true
]

{ #category : 'initialization' }
PulsarApplication >> newConfiguration [

	^ PulsarGtkConfiguration new
		applicationId: 'org.pharo.Pulsar';
		applicationClass: PanelApplication;
		yourself
]

{ #category : 'ui - dialogs' }
PulsarApplication >> newConfirm [

	^ (PulsarConfirmDialog newApplication: self)
		parentWindow: self topWindow;
		yourself
]

{ #category : 'private - factory' }
PulsarApplication >> newIconProvider [

	^ (PvAliasedVSCodeIconProvider new
			application: self;
			addLocation: self resourcesDir / 'vscode-extraicons';
			addLocation: self resourcesDir / 'vscode-icons';
			addLocation: self resourcesDir / 'vscode-codicons';
			yourself),
	  PvDefaultIconProvider new
]

{ #category : 'ui - dialogs' }
PulsarApplication >> newInform [

	^ (PulsarInformDialog newApplication: self)
		parentWindow: self topWindow;
		yourself
]

{ #category : 'ui - dialogs' }
PulsarApplication >> newRequest [

	^ (PulsarRequestDialog newApplication: self) 
		parentWindow: self topWindow;
		yourself
]

{ #category : 'ui - dialogs' }
PulsarApplication >> newRequestText [

	^ (PulsarRequestTextDialog newApplication: self) 
		parentWindow: self topWindow;
		yourself
]

{ #category : 'private - scheduling' }
PulsarApplication >> newScheduler [ 

	^ TKTWorkerPool new
		name: self className;
		poolMaxSize: 5;
		start
]

{ #category : 'ui - dialogs' }
PulsarApplication >> newSelect [

	^ (PulsarSelectDialog newApplication: self)
		parentWindow: self topWindow;
		yourself
]

{ #category : 'private - factory' }
PulsarApplication >> newSettings [

	^ PvActionSettings new
		"this can change by platform (linux, mac or windows)"
		mod1: Smalltalk os mod1;
		mod2: Smalltalk os mod2;
		mod3: Smalltalk os mod3;
		yourself
]

{ #category : 'accessing' }
PulsarApplication >> osPlatform [
	"answer current platform (mac, windows or linux)"

	^ OSPlatform current
]

{ #category : 'initialization' }
PulsarApplication >> prepareAsStandaloneApplication [
	
	standalone := true.
	self cleanUp.
	self killUnusedProcesses.
	self prepareSchedulerAsStandaloneApplication.
	self prepareErrorHandlerAsStandaloneApplication
]

{ #category : 'initialization' }
PulsarApplication >> prepareErrorHandlerAsStandaloneApplication [

	PulsarUIManager activateOn: self.
	ErrorHandler default: PulsarErrorHandler new.
	OupsDebuggerSelectionStrategy debuggerSelectionStrategy: (PulsarSingleDebuggerSelector on: self)
]

{ #category : 'accessing' }
PulsarApplication >> pulsarBrowser [
	"for now the application will have just one Pulsar active (it can have a lot more windows, but more than 
	 one dock feels very disturbing)"
	 
	 ^ self windows 
	 	detect: [ :each | each class = PulsarBrowser ]
	 	ifNone: [ nil ]
]

{ #category : 'private - scheduling' }
PulsarApplication >> queueTask: aBlock [
	"queue task works on a single working, ensure tasks are queued 
	 (they will happen in FIFO order)"

	^ self scheduler schedule: [
		aBlock 
			on: Error 
			fork: [ :e | e pass ] ]
]

{ #category : 'initialization' }
PulsarApplication >> registerToSystemEvents [

	"this way I have just one subscription for each application, that will be broadcasted to 
	 all applications windows"
	self class codeChangeAnnouncer weak
		when: SystemAnnouncement 
		send: #resendAnnouncement: 
		to: self
]

{ #category : 'initialization' }
PulsarApplication >> reloadConfiguration [

	^ self configuration reloadOnApplication: self
]

{ #category : 'announcing' }
PulsarApplication >> resendAnnouncement: anAnnouncement [
	
	self windows do: [ :aWindowPresenter |
		aWindowPresenter announce: anAnnouncement ]
]

{ #category : 'private - factory' }
PulsarApplication >> resourcesDir [
	
	^ IceRepository registry 
		detect: [ :each | each name = 'Pulsar' ]
		ifFound: [ :aRepository | aRepository location / 'resources' ]
		ifNone: [ FileLocator imageDirectory / 'resources' ].
]

{ #category : 'running' }
PulsarApplication >> run [

	self class running ifNotNil: [ :anApplication | 
		anApplication shutDown: false ].
	self start.
	self class running: self
]

{ #category : 'schedulling' }
PulsarApplication >> schedule: aBlock [

	self 
		deprecated: 'This is confusing, use #scheduleTask:' 
		transformWith: 
			'`@receiver schedule: `@arg' -> 
			'`@receiver scheduleTask: `@arg'.

	^ self scheduleTask: aBlock
]

{ #category : 'private - scheduling' }
PulsarApplication >> scheduleTask: aBlock [

	^ self scheduler schedule: [ 
		aBlock 
			on: Error 
			fork: [ :e | e pass ] ]
]

{ #category : 'private - scheduling' }
PulsarApplication >> scheduler [

	^ scheduler ifNil: [ scheduler := self newScheduler ]
]

{ #category : 'accessing' }
PulsarApplication >> settings [

	^ self 
		propertyAt: #settings
		ifAbsentPut: [ PulsarSettings new ]
]

{ #category : 'system startup' }
PulsarApplication >> shutDown: quitting [

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
PulsarApplication >> snapshot [

	^ PulsarApplicationSnapshot on: self
]

{ #category : 'running' }
PulsarApplication >> start [
	| snapshot browser |
	
	snapshot := self class lastSnapshot.
	(snapshot isNotNil and: [ snapshot hasRecords ])
		ifTrue: [ snapshot restoreTo: self ]
		ifFalse: [ (PulsarBrowser newApplication: self) open ].

	self scheduleTask: [ self checkForLostChanges ]
]

{ #category : 'settings' }
PulsarApplication >> subscribeToSettingsAnnouncements [
	"do nothing, this thing will not work with morphic"
]

{ #category : 'private - events' }
PulsarApplication >> syntaxHighlightThemeChanged: ann [

	self propertyAt: #syntaxHighlightTheme put: ann newTheme.
	self resendAnnouncement: ann
]

{ #category : 'accessing' }
PulsarApplication >> systemNavigation [

	^ PulsarSystemNavigation new
]

{ #category : 'accessing' }
PulsarApplication >> takeSnapshot [

	"do not take the snapshot if there is no windows, because like that I can keep 
	 the last one"
	self windows size > 0 ifFalse: [ ^ self ].
	self class lastSnapshot: self snapshot
]

{ #category : 'settings' }
PulsarApplication >> toolbarDisplayMode [

	^ SpToolbarDisplayMode modeIcon
]

{ #category : 'initialization' }
PulsarApplication >> useGtkDark [

	self 
		useBackend: #Gtk 
		with: self newConfiguration forceDark
]

{ #category : 'initialization' }
PulsarApplication >> useGtkLight [

	self 
		useBackend: #Gtk 
		with: self newConfiguration forceLight
]

{ #category : 'accessing' }
PulsarApplication >> windowWillClose: aPulsarWindow [
	"check if the dockbrowser can be safely saved.
	 WARNING: as this method execution has to happen inside a gtk callback , we do not have 
	 debugger fallback if something is wrong. Take care!"
	| anyEditorDirty canClose modifiedEditors messages lostChanges |
	
	canClose := false.
	
	"I'm keeping a snapshot of last open window :)"
	
	[ 
		self windows size = 1 
			ifTrue: [ self takeSnapshot ].

		messages := OrderedCollection new.
	
		"check if editors are modified"
		modifiedEditors := OrderedCollection new.
		anyEditorDirty:= false.
		aPulsarWindow editors reversed do: [ :each | 
			| ann  |
			ann := SpWindowWillClose new.
			ann window: each.
			each presenter announce: ann.
			ann canClose ifFalse: [
				anyEditorDirty := true.  
				modifiedEditors add: each title ] ]. 
		anyEditorDirty ifTrue: [
			messages add: ('There are modified editors: ', (String cr join: modifiedEditors)) ].
		
		self flag: #TODO. "check last snapshot and see if there are changes to save. This line is not working 
		(it works just at the startup actions, hence is not useful for us)"
		lostChanges  := EpLostChangesDetector new hasLostChanges.
		lostChanges ifTrue: [
			messages add: 'The image has unsaved changes.' ].
		
		"if not all exit conditions are satisfied, open a dialog"
		canClose := (anyEditorDirty or: [ lostChanges ])
			ifTrue: [
				self newConfirm 
					title: 'Quit Pharo?';
					"message: (
						(String cr join: messages),
						String cr, 'Quit anyway?');"  
					message: 'There are unsaved changes in your environment.<n>Quit anyway?' expandMacros;
					cancelLabel: 'Stay';
					acceptLabel: 'Quit';
					openModalWithParent: aPulsarWindow ]
			ifFalse: [
				true ] ]
		on: Error 
		fork: [ :e | e pass ].

	^ canClose
]
