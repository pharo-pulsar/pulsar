Class {
	#name : 'PulsarUIManager',
	#superclass : 'NonInteractiveUIManager',
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'activation' }
PulsarUIManager class >> activateOn: anApplication [

	UIManager default: self new
]

{ #category : 'testing' }
PulsarUIManager class >> isValidForCurrentSystemConfiguration [
	^ false
]

{ #category : 'initialization' }
PulsarUIManager class >> reset [
	<reset>

	
]

{ #category : 'accessing' }
PulsarUIManager >> application [

	^ nil
]

{ #category : 'ui requests' }
PulsarUIManager >> chooseFrom: optionsArray lines: linesArray title: aString [
	| result |
	
	self flag: #TODO. "Using this is wrong (as everything on UIManager)"

	self halt
]

{ #category : 'error handling' }
PulsarUIManager >> handleError: anError [

	Smalltalk
		logError: anError messageText
		inContext: anError signalerContext.

	(OupsDebugRequest newForException: anError) submit
]

{ #category : 'error handling' }
PulsarUIManager >> handleNotification: aNotification [

	"by default, do nothing"
	
	aNotification resume 
]

{ #category : 'error handling' }
PulsarUIManager >> handleWarning: aWarning [
	"The user should be notified of the occurrence of an exceptional occurrence and given an option of continuing or aborting the computation. The description of the occurrence should include any text specified as the argument of the #signal: message."

	(OupsWarningRequest newForException: aWarning) submit
]

{ #category : 'ui requests' }
PulsarUIManager >> informUser: aString during: aBlock [

	self flag: #TODO. "Using informUser:during: is wrong (as everything on UIManager)"
	^ aBlock value
]
