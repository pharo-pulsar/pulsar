Class {
	#name : 'DockUIManager',
	#superclass : 'NonInteractiveUIManager',
	#classInstVars : [
		'application'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'activation' }
DockUIManager class >> activateOn: anApplication [

	"I need this variable because if I save the image it will reset the UIManager (but the 
	 application will still ne running!)."
	application := anApplication.
	UIManager default: self new.
	ErrorHandler defaultErrorHandler: UIManager default

]

{ #category : 'private' }
DockUIManager class >> application [

	^ application
]

{ #category : 'testing' }
DockUIManager class >> isValidForCurrentSystemConfiguration [

	^ self application isNotNil
]

{ #category : 'initialization' }
DockUIManager class >> reset [
	<reset>

	application := nil
]

{ #category : 'error handling' }
DockUIManager >> handleError: anError [

	Smalltalk
		logError: anError messageText
		inContext: anError signalerContext.

	(OupsDebugRequest newForException: anError) submit
]
