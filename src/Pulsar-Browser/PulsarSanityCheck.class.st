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
	
	self log: '📚 Verifying '; log: aClass name.
	self log: '. Present: '.
	
	[ name := aClass uniqueInstance libraryName ]
	on: Error 
	do: [ :e | 
		self log: '❌'.
		self newLine.
		error := true.
		^ self ].
	
	self log: '✅'.
	self log: ' (', name, ')'.
	self log: '. Load: '.
	
	(DynamicLoader loadLibrary: name) isNullOrNil 
		ifTrue: [ 
			self log: '❌'.
			error := true ]
		ifFalse: [ 
			self log: '✅' ].
	
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

	GObjectLibrary withAllSubclasses 
		do: [ :each | self checkLibrary: each ].
	self checkLibrary: LibResvg.
	
	error ifTrue: [
		self log: '☠️ Sanity check do not pass. Exiting.'.
		Exit signalFailure ].
	
	^ error
]
