Class {
	#name : 'DockSingleDebuggerSelector',
	#superclass : 'OupsSingleDebuggerSelector',
	#instVars : [
		'application'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'instance creation' }
DockSingleDebuggerSelector class >> on: anApplication [

	^ self new 
		application: anApplication;
		yourself
]

{ #category : 'initialization' }
DockSingleDebuggerSelector >> application: anApplication [

	application := anApplication
]

{ #category : 'accessing' }
DockSingleDebuggerSelector >> nextDebugger [

	logger trace: debuggers.
	^ DockDebugger newApplication: application
]

{ #category : 'instance creation' }
DockSingleDebuggerSelector >> with: aCollection [
	"I do not care as I will not be using it like this (and I will set my strategy as an instance"
	
	debuggers := aCollection
]
