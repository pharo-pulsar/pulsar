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

{ #category : 'accessing' }
DockUIManager >> application [

	^ self class application
]

{ #category : 'ui requests' }
DockUIManager >> chooseFrom: optionsArray lines: linesArray title: aString [
	| result |
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
DockUIManager >> handleError: anError [

	Smalltalk
		logError: anError messageText
		inContext: anError signalerContext.

	(OupsDebugRequest newForException: anError) submit
]
