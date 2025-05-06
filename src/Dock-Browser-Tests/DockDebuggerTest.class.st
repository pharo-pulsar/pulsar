Class {
	#name : 'DockDebuggerTest',
	#superclass : 'TestCase',
	#instVars : [
		'debugger',
		'application',
		'session'
	],
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'accessing' }
DockDebuggerTest >> application [

	^ application ifNil: [ application := DockApplication new ]
]

{ #category : 'accessing' }
DockDebuggerTest >> debugger [

	^ debugger ifNil: [ debugger := self newDebugger ]
]

{ #category : 'private' }
DockDebuggerTest >> ensureClearSession [

	session ifNotNil: #clear
]

{ #category : 'private' }
DockDebuggerTest >> ensureCloseDebugger [
	
	debugger ifNotNil: [ 
		debugger close.
		debugger := nil ]
]

{ #category : 'private - factory' }
DockDebuggerTest >> newDebugger [

	^ (DockDebugger newApplication: self application)
		session: self session;
		yourself
]

{ #category : 'private - factory' }
DockDebuggerTest >> newSession [

	^ StTestDebuggerProvider new sessionForDebuggerTests
]

{ #category : 'accessing' }
DockDebuggerTest >> session [

	^ session ifNil: [ session := self newSession ]
]

{ #category : 'running' }
DockDebuggerTest >> tearDown [
	self ensureCloseDebugger.
		super tearDown
]

{ #category : 'tests' }
DockDebuggerTest >> testSmoke [

	self debugger open
]
