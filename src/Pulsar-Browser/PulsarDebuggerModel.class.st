Class {
	#name : 'PulsarDebuggerModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'session',
		'stack',
		'actionModel'
	],
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'instance creation' }
PulsarDebuggerModel class >> on: aSession [

	^ self new 
		session: aSession;
		yourself
]

{ #category : 'private' }
PulsarDebuggerModel >> actionModel [

	^ actionModel
]

{ #category : 'accessing' }
PulsarDebuggerModel >> clearSession [

	self session
		terminate;
		clear
]

{ #category : 'accessing' }
PulsarDebuggerModel >> entity: aDebugSession [

	logger trace: aDebugSession.
	actionModel := StDebuggerActionModel on: aDebugSession.
	logger trace: actionModel.
	super entity: aDebugSession
]

{ #category : 'accessing' }
PulsarDebuggerModel >> name [

	^ self session name
]

{ #category : 'accessing' }
PulsarDebuggerModel >> resetStack [

	stack := nil
]

{ #category : 'accessing' }
PulsarDebuggerModel >> session [

	^ self entity
]

{ #category : 'accessing' }
PulsarDebuggerModel >> session: aDebugSession [

	self entity: aDebugSession
]

{ #category : 'accessing' }
PulsarDebuggerModel >> stack [

	^ stack ifNil: [ 
		stack := (self actionModel filterStack: self session stack) 
			collect: [ :each | 
				PulsarContextModel 
					newEnvironment: self environmentModel
					debuggerModel: self
					context: each ] ]
]
