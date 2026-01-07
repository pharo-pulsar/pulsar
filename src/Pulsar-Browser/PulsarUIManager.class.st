Class {
	#name : 'PulsarUIManager',
	#superclass : 'NonInteractiveUIManager',
	#classInstVars : [
		'application'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'activation' }
PulsarUIManager class >> activateOn: anApplication [

	"I need this variable because if I save the image it will reset the UIManager (but the 
	 application will still ne running!)."
	application := anApplication.
	UIManager default: self new
]

{ #category : 'private' }
PulsarUIManager class >> application [

	^ application
]

{ #category : 'testing' }
PulsarUIManager class >> isValidForCurrentSystemConfiguration [

	^ self application isNotNil
]

{ #category : 'initialization' }
PulsarUIManager class >> reset [
	<reset>

	application := nil
]

{ #category : 'accessing' }
PulsarUIManager >> application [

	^ self class application
]

{ #category : 'ui requests' }
PulsarUIManager >> chooseFrom: optionsArray lines: linesArray title: aString [
	| result |
	
	self flag: #TODO. "Using this is wrong (as everything on UIManager)"

self halt.
	"this is lame because the code reparator uses a menu :/"
	result := self application newSelect
		title: aString;
		items: optionsArray;
		display: [ :each | 
			linesArray 
				ifNotEmpty: [ linesArray at: (optionsArray indexOf: each) ] 
				ifEmpty: [ each asString ] ];
		openModal.
		
	^ result ifNotNil: [ optionsArray indexOf: result ]
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
