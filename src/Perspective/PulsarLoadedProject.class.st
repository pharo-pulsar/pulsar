Class {
	#name : 'PulsarLoadedProject',
	#superclass : 'Object',
	#instVars : [
		'name',
		'baselineName',
		'packageNames',
		'origin',
		'version',
		'repository'
	],
	#category : 'Perspective',
	#package : 'Perspective'
}

{ #category : 'comparing' }
PulsarLoadedProject >> =

	other [
	^ self species = other species
		and: [ name = other name
		and: [ origin = other origin ] ]
]

{ #category : 'accessing' }
PulsarLoadedProject >> baselineName [

	^ baselineName
]

{ #category : 'accessing' }
PulsarLoadedProject >> baselineName: aString [

	baselineName := aString
]

{ #category : 'comparing' }
PulsarLoadedProject >> hash [

	^ (name hash bitXor: origin hash)
]

{ #category : 'testing' }
PulsarLoadedProject >> isResolved [

	"Answer whether Pulsar has a local repository for this loaded project."
	^ repository notNil
]

{ #category : 'accessing' }
PulsarLoadedProject >> name [

	^ name
]

{ #category : 'accessing' }
PulsarLoadedProject >> name: aString [

	name := aString
]

{ #category : 'accessing' }
PulsarLoadedProject >> origin [

	^ origin
]

{ #category : 'accessing' }
PulsarLoadedProject >> origin: anObject [

	origin := anObject
]

{ #category : 'accessing' }
PulsarLoadedProject >> packageNames [

	^ packageNames ifNil: [ #() ]
]

{ #category : 'accessing' }
PulsarLoadedProject >> packageNames: aCollection [

	packageNames := aCollection
]

{ #category : 'printing' }
PulsarLoadedProject >> printOn: aStream [

	aStream
		nextPutAll: 'PulsarLoadedProject(';
		nextPutAll: name asString;
		nextPutAll: ')'
]

{ #category : 'accessing' }
PulsarLoadedProject >> repository [

	^ repository
]

{ #category : 'accessing' }
PulsarLoadedProject >> repository: anObject [

	repository := anObject
]

{ #category : 'accessing' }
PulsarLoadedProject >> version [

	^ version
]

{ #category : 'accessing' }
PulsarLoadedProject >> version: anObject [

	version := anObject
]
