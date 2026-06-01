"
PulsarWhich locates executable programs on the system PATH.

It searches the PATH environment variable for a given program name,
with a fallback for Flatpak sandboxed environments. It is implemented
as a singleton accessed via `PulsarWhich uniqueInstance`.
"
Class {
	#name : 'PulsarWhich',
	#superclass : 'Object',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Pulsar-Tool-LLM-Model',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarWhich class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'utilities' }
PulsarWhich class >> pathForProgram: aString [

	^ self uniqueInstance pathForProgram: aString
]

{ #category : 'instance creation' }
PulsarWhich class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : 'private' }
PulsarWhich >> homePathFromFlatpakAsList [
	"this should work for linux/macOS and windows"
	| homePath |

	homePath := LibC resultOfCommand: 'flatpak-spawn --host sh -lc ''printf "%s\n" "$PATH"'''.
	^ homePath substrings: ':;'
]

{ #category : 'private' }
PulsarWhich >> isFlatpak [

	^ OSPlatform current isFlatpak
]

{ #category : 'private' }
PulsarWhich >> lookForProgram: aString atAnyOf: aCollection [

	aCollection do: [ :eachDir |
			OSPlatform current executableExtensions do: [ :ext |
					| fullPath |
					fullPath := eachDir asFileReference / (aString , ext).
					fullPath exists ifTrue: [ ^ fullPath fullName ] ] ].

	^ nil
]

{ #category : 'private' }
PulsarWhich >> pathAsList [
	"this should work for linux/macOS and windows"

	^ (OSEnvironment current at: 'PATH') substrings: ':;'
]

{ #category : 'utilities' }
PulsarWhich >> pathForProgram: aString [
	
	"First look for it in the regular PATH."
	(self lookForProgram: aString atAnyOf: self pathAsList) ifNotNil: [ :aFullPath | ^ aFullPath ]. 
	
	"If this is a Flatpak, it may be in the real PATH outside the sandbox."
	self isFlatpak ifTrue: [
		(self lookForProgram: aString atAnyOf: self homePathFromFlatpakAsList) 
			ifNotNil: [ :aFullPath | ^ aFullPath ] ]. 
	
	"Not found, answer nil."
	^ nil
]
