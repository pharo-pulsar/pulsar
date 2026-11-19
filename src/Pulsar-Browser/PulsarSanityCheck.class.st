"
A one-shot probe of the runtime environment, run when Pulsar starts as a standalone application. It answers a single question — can this VM, on this machine, drive the GTK native stack the IDE depends on — and stops the launch when it cannot, so a broken installation fails visibly at startup instead of hanging or crashing once the first window is on screen.

The conditions fall into three kinds. Platform-specific ones are contributed through the OSPlatform visitor protocol, so each platform states only what is true for it: on Linux, for example, that the VM is not a zeroconf build carrying its own copy of the native libraries, which clashes with the system GTK. The VM itself must be running in a worker thread, the mode in which the GTK main loop and the Pharo scheduler can coexist. Finally, the native libraries Pulsar binds to are resolved by name and loaded, which reports a missing or misconfigured library early and leaves the libraries loaded for the session; GSettings schema support is prepared before that step, because resolving those libraries needs the settings backend.

Output is one line per check on standard output, with a pass/fail marker, so the reason for a refused launch stays readable in a terminal or launcher log even though no UI ever appears. How much of that detail is shown follows whether logging is enabled: quiet by default, per-check report when a logger is active. State is just the record of whether anything failed, accumulated across all checks rather than stopping at the first problem, so the whole picture of a broken environment is reported before startup aborts with a failing Exit.

Expected to be used once, at launch: see PulsarApplication>>prepareAsStandaloneApplication, reached from the command-line startup path. Keeping it accurate as the IDE's native dependencies change means recording the library set and any platform condition that has to hold.
```smalltalk
    PulsarSanityCheck new run
```

Answers false when every check passed. It is written for startup: on a bad environment it signals the failing Exit, which would abort a running image, so evaluating it in a development image is not safe.
"
Class {
	#name : 'PulsarSanityCheck',
	#superclass : 'Object',
	#instVars : [
		'error',
		'logStream'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'private' }
PulsarSanityCheck >> checkLibrary: aClass [
	| name |

	logger trace: aClass name.
	
	self log: '📖 '; log: (aClass name padRightTo: 25).
	self log: ': Found  '.
	
	[ name := aClass uniqueInstance libraryName ]
	on: Error 
	do: [ :e | 
		self log: 'No ❌'.
		self newLine.
		error := true.
		^ self ].
	
	self log: 'Yes ✅'.
	self log: (' [', name, '] ' padRightTo: 50).
	self log: 'load: '.
	
	(DynamicLoader loadLibrary: name) isNullOrNil 
		ifTrue: [ 
			self log: 'No ❌'.
			error := true ]
		ifFalse: [ 
			self log: 'Yes ✅' ].
	
	self newLine
]

{ #category : 'running' }
PulsarSanityCheck >> checkThreadedVM [
	| result |

	self log: '⛑️  Virtual Machine running in Worker thread: '.
	result := Smalltalk vm isRunningInWorkerThread.

	result 
		ifTrue: [ self log: 'Yes ✅' ]
		ifFalse: [ self log: 'No ❌'. error := true ].
		
	self newLine
]

{ #category : 'private' }
PulsarSanityCheck >> forceLog: aString [

	Stdio stdout << aString utf8Encoded
]

{ #category : 'private' }
PulsarSanityCheck >> forceNewLine [

	Stdio stdout << OSPlatform current lineEnding; flush
]

{ #category : 'private' }
PulsarSanityCheck >> log: aString [

	logger isEnabled ifFalse: [ ^ self ]. 
	self forceLog: aString
]

{ #category : 'private' }
PulsarSanityCheck >> newLine [

	logger isEnabled ifFalse: [ ^ self ].
	self forceNewLine
]

{ #category : 'running' }
PulsarSanityCheck >> run [

	error := false.
	"verify platform specific stuff"	
	OSPlatform current accept: self.
	"verify threaded vm"
	self checkThreadedVM.
	"verify libraries.
	 I need to make a pass for the settings schema support because 
	 initialization of libraries will require settings"
	GtkGSettingsSchemaSupport new start.
	self usingLibraries 
		do: [ :each | self checkLibrary: each ].
		
	error ifTrue: [
		logger isEnabled 
			ifTrue: [ 
				self 
					log: '💀 Sanity check do not pass. Terminating...'; 
					newLine ]
			ifFalse: [
				self 
					forceLog: 'Sanity check do not pass (run with -v for details). Terminating...'; 
					forceNewLine ].
		Exit signalFailure ].
		
	self log: '⭐ Everything looks fine! Starting...'.
	self newLine.
	
	^ error
]

{ #category : 'private' }
PulsarSanityCheck >> usingLibraries [

	^ OrderedCollection new
		addAll: GObjectLibrary withAllSubclasses;
		add: GtkSourceViewLibrary;
		add: LibRsvg;
		add: VteLibrary;
		yourself
]

{ #category : 'visiting' }
PulsarSanityCheck >> visitMacOSX: aPlatform [
]

{ #category : 'visiting' }
PulsarSanityCheck >> visitUnix64: aPlatform [

	"verify I am not running in a zeroconf downloaded library"
	self log: '⛑️  Virtual Machine is NOT Zeroconf: '.
	"if it has sdl in its directory, is zeroconf"
	(FileLocator vmDirectory / 'libSDL2.so') exists 
		ifTrue: [ self log: 'It is ❌'. error := true ]
		ifFalse: [  self log: 'Ok ✅' ].
		
	self newLine
	

]

{ #category : 'visiting' }
PulsarSanityCheck >> visitWindows64: self [
]
