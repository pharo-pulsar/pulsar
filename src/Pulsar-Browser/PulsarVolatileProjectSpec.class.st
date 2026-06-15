"
I am a lightweight registry entry for a standalone project that survives image restarts. I store only a name and package names — no environment or model references. PulsarStandaloneProjectModel instances are materialized from me on browser initialization.
"
Class {
	#name : 'PulsarVolatileProjectSpec',
	#superclass : 'Object',
	#instVars : [
		'name',
		'packageNames'
	],
	#classVars : [
		'VolatileProjectSpecs'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing' }
PulsarVolatileProjectSpec class >> named: aName [

	^ self specs detect: [ :each | each name = aName ] ifNone: [ nil ]
]

{ #category : 'registering' }
PulsarVolatileProjectSpec class >> registerProjectNamed: aName packageNames: aCollection [

	| spec |
	spec := self new.
	spec name: aName.
	aCollection do: [ :each | spec addPackageNamed: each ].
	self specs add: spec
]

{ #category : 'accessing' }
PulsarVolatileProjectSpec class >> specs [

	(VolatileProjectSpecs isNil or: [ (VolatileProjectSpecs isKindOf: OrderedCollection) not ]) ifTrue: [
		VolatileProjectSpecs := OrderedCollection new ].
	^ VolatileProjectSpecs
]

{ #category : 'registering' }
PulsarVolatileProjectSpec class >> unregisterProjectNamed: aName [

	self specs detect: [ :each | each name = aName ] ifFound: [ :spec | self specs remove: spec ] ifNone: [ ]
]

{ #category : 'accessing' }
PulsarVolatileProjectSpec >> addPackageNamed: aName [

	packageNames addIfNotPresent: aName
]

{ #category : 'initialization' }
PulsarVolatileProjectSpec >> initialize [

	super initialize.
	packageNames := OrderedCollection new
]

{ #category : 'accessing' }
PulsarVolatileProjectSpec >> name [

	^ name
]

{ #category : 'accessing' }
PulsarVolatileProjectSpec >> name: aString [

	name := aString
]

{ #category : 'accessing' }
PulsarVolatileProjectSpec >> packageNames [

	^ packageNames
]
