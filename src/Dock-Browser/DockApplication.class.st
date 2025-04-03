Class {
	#name : 'DockApplication',
	#superclass : 'StPharoApplication',
	#traits : 'DockTScheduling',
	#classTraits : 'DockTScheduling classTrait',
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

{ #category : 'private' }
DockApplication class >> cleanUp [
	<script>

	"yes, there are better ways to do this, for for now..."
	DockWorker allInstances do: #stop.
	Transcript dependents copy
		collect: [ :each | each isKindOf: DockTranscript ]
		thenDo: [ :each | Transcript removeDependent: each ]
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

	running := nil.
	self resetLastSnapshot
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
	self running: nil.
	self cleanUp
]

{ #category : 'system startup' }
DockApplication class >> startUp: resuming [

	resuming ifFalse: [ ^ self ].
	self cleanUp
]

{ #category : 'accessing' }
DockApplication >> colorNamed: aString [

	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : 'accessing' }
DockApplication >> iconCache [

	^ self 
		propertyAt: #iconCache 
		ifAbsentPut: [ PvCompositeIconCache new ]
]

{ #category : 'initialization' }
DockApplication >> initialize [

	super initialize
]

{ #category : 'initialization' }
DockApplication >> initializeConfiguration [

	super initializeConfiguration.
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

{ #category : 'private - factory' }
DockApplication >> newIconProvider [

	^ (PvAliasedVSCodeIconProvider new
			application: self;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'vscode-extraicons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'vscode-icons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'vscode-codicons') asFileReference;
			yourself),
	 (PvLocationWithThemeIconProvider new
			application: self;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'idea-extraicons') asFileReference;
			addLocation: (FileLocator imageDirectory / 'perspective' / 'idea-icons') asFileReference;
			yourself),
	  StPharoDefaultIconProvider new, 
	  SgaGtkThemeIconProvider new,
	  PvDefaultIconProvider new
]

{ #category : 'private - scheduling' }
DockApplication >> newScheduler [ 

	^ TKTWorkerPool new
		poolMaxSize: 5;
		start
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
	"1hr... maybe too much?"
	Smalltalk vm isRunningInWorkerThread 
		ifTrue: [ ProcessorScheduler idleTime: 3600000000 ]
]

{ #category : 'running' }
DockApplication >> run [

	self class running ifNotNil: [ :anApplication | 
		anApplication shutDown: false ].
	self start.
	self class running: self
]

{ #category : 'system startup' }
DockApplication >> shutDown: quitting [

	self takeSnapshot
]

{ #category : 'accessing' }
DockApplication >> snapshot [

	^ DockApplicationSnapshot on: self
]

{ #category : 'running' }
DockApplication >> start [
	| snapshot |

	snapshot := self class lastSnapshot.
	(snapshot isNotNil and: [ snapshot hasRecords ]) ifTrue: [ 
		snapshot restoreTo: self.
		^ self ].
		
	(self new: DockBrowser) open
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
