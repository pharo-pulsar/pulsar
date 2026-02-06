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
		self log: '❌'.
		self newLine.
		error := true.
		^ self ].
	
	self log: '✅'.
	self log: (' [', name, '] ' padRightTo: 50).
	self log: 'load: '.
	
	(DynamicLoader loadLibrary: name) isNullOrNil 
		ifTrue: [ 
			self log: '❌'.
			error := true ]
		ifFalse: [ 
			self log: '✅' ].
	
	self newLine
]

{ #category : 'running' }
PulsarSanityCheck >> checkThreadedVM [
	| result |

	self log: '⛑️  Virtual Machine running in Worker thread: '.
	result := Smalltalk vm isRunningInWorkerThread.

	result 
		ifTrue: [ self log: '✅' ]
		ifFalse: [ self log: '❌'. error := true ].
		
	self newLine
]

{ #category : 'private' }
PulsarSanityCheck >> log: aString [

	Stdio stdout << aString utf8Encoded
]

{ #category : 'private' }
PulsarSanityCheck >> newLine [

	Stdio stdout << OSPlatform current lineEnding
]

{ #category : 'running' }
PulsarSanityCheck >> run [

	error := false.

	"verify threaded vm"
	self checkThreadedVM.
	"libraries"
	self usingLibraries 
		do: [ :each | self checkLibrary: each ].
	
	error ifTrue: [
		self log: '☠️ Sanity check do not pass. Exiting.'.
		Exit signalFailure ].
	
	^ error
]

{ #category : 'private' }
PulsarSanityCheck >> usingLibraries [

	^ OrderedCollection new
		addAll: GObjectLibrary withAllSubclasses;
		add: GtkSourceViewLibrary;
		add: LibResvg;
		yourself
]
