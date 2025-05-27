Class {
	#name : 'DockDebuggerModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'session',
		'stack',
		'actionModel'
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

{ #category : 'private' }
DockDebuggerModel >> actionModel [

	^ actionModel
]

{ #category : 'accessing' }
DockDebuggerModel >> clearSession [

	self session
		terminate;
		clear
]

{ #category : 'accessing' }
DockDebuggerModel >> entity: aDebugSession [

	logger trace: aDebugSession.
	actionModel := StDebuggerActionModel on: aDebugSession.
	logger trace: actionModel.
	super entity: aDebugSession
]

{ #category : 'accessing' }
DockDebuggerModel >> name [

	^ self session name
]

{ #category : 'accessing' }
DockDebuggerModel >> resetStack [

	stack := nil
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
		stack := (self actionModel filterStack: self session stack) 
			collect: [ :each | 
				DockContextModel 
					newEnvironment: self environmentModel
					debuggerModel: self
					context: each ] ]
]
