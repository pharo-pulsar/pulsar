Class {
	#name : 'PulsarDebuggerTest',
	#superclass : 'TestCase',
	#instVars : [
		'debugger',
		'application',
		'session'
	],
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarDebuggerTest >> application [

	^ application ifNil: [ application := PulsarApplication new ]
]

{ #category : 'accessing' }
PulsarDebuggerTest >> debugger [

	^ debugger ifNil: [ debugger := self newDebugger ]
]

{ #category : 'private' }
PulsarDebuggerTest >> ensureClearSession [

	session ifNotNil: #clear
]

{ #category : 'private' }
PulsarDebuggerTest >> ensureCloseDebugger [
	
	debugger ifNotNil: [ 
		debugger close.
		debugger := nil ]
]

{ #category : 'private - factory' }
PulsarDebuggerTest >> newDebugger [

	^ (PulsarDebugger newApplication: self application)
		session: self session;
		yourself
]

{ #category : 'private - factory' }
PulsarDebuggerTest >> newSession [

	^ StTestDebuggerProvider new sessionForDebuggerTests
]

{ #category : 'accessing' }
PulsarDebuggerTest >> session [

	^ session ifNil: [ session := self newSession ]
]

{ #category : 'running' }
PulsarDebuggerTest >> tearDown [
	self ensureCloseDebugger.
		super tearDown
]

{ #category : 'tests' }
PulsarDebuggerTest >> testSmoke [

	self debugger open
]
