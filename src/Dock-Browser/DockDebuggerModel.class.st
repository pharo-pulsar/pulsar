Class {
	#name : 'DockDebuggerModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'session',
		'stack'
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
DockDebuggerModel >> name [

	^ self session name
]

{ #category : 'accessing' }
DockDebuggerModel >> session [

	^ self entity
]

{ #category : 'accessing' }
DockDebuggerModel >> session: aDebugSession [

	self entity: aDebugSession
]

{ #category : 'accessing' }
DockDebuggerModel >> stack [

	^ stack ifNil: [ 
		stack := self session stack collect: [ :each | 
			DockContextModel 
				newEnvironment: self environmentModel 
				session: self session
				context: each ] ]
]
