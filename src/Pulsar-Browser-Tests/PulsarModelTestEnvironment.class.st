Class {
	#name : 'PulsarModelTestEnvironment',
	#superclass : 'Object',
	#classInstVars : [
		'current'
	],
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarModelTestEnvironment class >> current [

	^ current ifNil: [ current := PulsarSystemEnvironment new ]
]

{ #category : 'accessing' }
PulsarModelTestEnvironment class >> current: anEnvironment [

	current := anEnvironment
]

{ #category : 'accessing' }
PulsarModelTestEnvironment class >> reset [

	current := nil
]

{ #category : 'running' }
PulsarModelTestEnvironment class >> with: anEnvironment do: aBlock [

	| previous result |
	previous := self current.
	[ self current: anEnvironment. result := aBlock value ]
		ensure: [ self current: previous ].
	^ result
]
