Class {
	#name : 'PulsarSanityCheck',
	#superclass : 'Object',
	#instVars : [
		'error'
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
PulsarSanityCheck >> log: aString [

	Stdio stdout << aString utf8Encoded
]

{ #category : 'private' }
PulsarSanityCheck >> newLine [

	Stdio stdout << OSPlatform current lineEnding; flush.
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
		self log: '💀 Sanity check do not pass. Terminating...'.
		self newLine.
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
