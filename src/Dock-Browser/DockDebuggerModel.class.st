Class {
	#name : 'DockDebuggerModel',
	#superclass : 'Object',
	#instVars : [
		'session'
	],
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'instance creation' }
DockDebuggerModel class >> on: aSession [

	^ self new 
		session: aSession;
		yourself
]

{ #category : 'accessing' }
DockDebuggerModel >> session [

	^ session
]

{ #category : 'accessing' }
DockDebuggerModel >> session: aDebugSession [

	session := aDebugSession
]
