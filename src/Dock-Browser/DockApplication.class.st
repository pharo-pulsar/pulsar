Class {
	#name : 'DockApplication',
	#superclass : 'StPharoApplication',
	#traits : 'DockTScheduling',
	#classTraits : 'DockTScheduling classTrait',
	#instVars : [
		'name',
		'standalone'
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

{ #category : 'accessing' }
DockApplication >> snapshot [
	| newSnapshot |
	
	newSnapshot := DockSnapshot new.
	self windows do: [ :each | each recordSnapshotTo: newSnapshot ].
	^ newSnapshot
]

{ #category : 'running' }
DockApplication >> start [

	(self new: DockBrowser) open
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
