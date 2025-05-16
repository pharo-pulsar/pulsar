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

{ #category : 'testing' }
DockDebuggerModel >> canExecuteDebugCommand [

	^ self actionModel isContextSteppable
]

{ #category : 'testing' }
DockDebuggerModel >> canExecuteRestartCommand [

	^ (self actionModel isInterruptedContextPostMortem 
		or: [ self actionModel isInterruptedContextDead ]) not
]

{ #category : 'testing' }
DockDebuggerModel >> canExecuteReturnCommand [

	^ self actionModel isInterruptedContextDead not
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

{ #category : 'actions' }
DockDebuggerModel >> proceedDebugSession [

	self actionModel proceedDebugSession
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

{ #category : 'actions' }
DockDebuggerModel >> stepInto: aContextModel [

	self actionModel stepInto: aContextModel entity
]

{ #category : 'actions' }
DockDebuggerModel >> stepOver: aContextModel [

	self actionModel stepOver: aContextModel entity
]

{ #category : 'actions' }
DockDebuggerModel >> stepThrough: aContextModel [

	self actionModel stepThrough: aContextModel entity
]
