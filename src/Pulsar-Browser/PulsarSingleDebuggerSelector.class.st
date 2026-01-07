Class {
	#name : 'PulsarSingleDebuggerSelector',
	#superclass : 'OupsSingleDebuggerSelector',
	#instVars : [
		'application'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'instance creation' }
PulsarSingleDebuggerSelector class >> on: anApplication [

	^ self new 
		application: anApplication;
		yourself
]

{ #category : 'initialization' }
PulsarSingleDebuggerSelector >> application: anApplication [

	application := anApplication
]

{ #category : 'accessing' }
PulsarSingleDebuggerSelector >> nextDebugger [

	logger trace: debuggers.
	^ PulsarDebugger newApplication: application
]

{ #category : 'instance creation' }
PulsarSingleDebuggerSelector >> with: aCollection [
	"I do not care as I will not be using it like this (and I will set my strategy as an instance"
	
	debuggers := aCollection
]
