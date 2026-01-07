Class {
	#name : 'PulsarErrorHandler',
	#superclass : 'NonInteractiveErrorHandler',
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'testing' }
PulsarErrorHandler class >> isValidForCurrentSystemConfiguration [

	^ true
]

{ #category : 'error handling' }
PulsarErrorHandler >> handleError: anError log: shouldLog [

	shouldLog ifTrue: [ self logError: anError ].
	(OupsDebugRequest newForException: anError) submit
]
