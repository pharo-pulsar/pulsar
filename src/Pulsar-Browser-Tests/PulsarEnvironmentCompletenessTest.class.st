Class {
	#name : 'PulsarEnvironmentCompletenessTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'tests' }
PulsarEnvironmentCompletenessTest >> testAbstractProtocolIsFullyImplemented [

	| missing |
	missing := PulsarEnvironment selectors reject: [ :sel |
		PulsarSystemEnvironment canUnderstand: sel ].
	self assert: missing isEmpty
]

{ #category : 'tests' }
PulsarEnvironmentCompletenessTest >> testSystemEnvironmentDoesNotAddUndocumentedProtocol [

	| extra |
	extra := PulsarSystemEnvironment selectors reject: [ :sel |
		PulsarEnvironment canUnderstand: sel ].
	self assert: (extra difference: #(
		organizer
		loadedProjectFor:
		originOfRepository:
		versionOfRepository:)) isEmpty
]
