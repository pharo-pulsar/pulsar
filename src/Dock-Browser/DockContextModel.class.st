Class {
	#name : 'DockContextModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'name',
		'debuggerModel'
	],
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'instance creation' }
DockContextModel class >> newEnvironment: anEnvironmentModel debuggerModel: aDebuggerModel context: aContext [

	^ (self newEnvironment: anEnvironmentModel entity: aContext)
		debuggerModel: aDebuggerModel;
		yourself
]

{ #category : 'comparing' }
DockContextModel >> = other [

	self species = other species ifFalse: [ ^ false ].
	^ self entity = other entity
]

{ #category : 'accessing' }
DockContextModel >> actionDecorators [

	^ self actions actionsFor: #decoration
]

{ #category : 'private - accessing' }
DockContextModel >> actionModel [

	^ self debuggerModel actionModel
]

{ #category : 'debug - testing' }
DockContextModel >> canExecuteDebugCommand [

	^ self actionModel isContextSteppable
]

{ #category : 'debug - testing' }
DockContextModel >> canExecuteRestartCommand [

	^ (self actionModel isInterruptedContextPostMortem 
		or: [ self actionModel isInterruptedContextDead ]) not
]

{ #category : 'debug - testing' }
DockContextModel >> canExecuteReturnCommand [

	^ self actionModel isInterruptedContextDead not
]

{ #category : 'accessing' }
DockContextModel >> context [

	"a synonym for clarity"
	^ self entity
]

{ #category : 'private - accessing' }
DockContextModel >> debuggerModel [

	^ debuggerModel
]

{ #category : 'initialization' }
DockContextModel >> debuggerModel: aDebuggerModel [

	debuggerModel := aDebuggerModel
]

{ #category : 'accessing' }
DockContextModel >> fullName [

	^ self name
]

{ #category : 'comparing' }
DockContextModel >> hash [

	^ self species hash bitXor: self entity
]

{ #category : 'private' }
DockContextModel >> inOneLine [
	"put the context in one line requires some work as e.g. blocks can't be 'just'
	 printed (as they are often not visible)"
	| string |

	string := ((self entity asString
		truncateWithElipsisTo: 200)
		copyReplaceAll: String cr with: ' ')
		copyReplaceAll: String tab with: ' '.

	[ string includesSubstring: '   ' ] 
	whileTrue: [ string := string copyReplaceAll: '   ' with: ' ' ].
	
	^ string
]

{ #category : 'accessing' }
DockContextModel >> method [

	^ self entity method
]

{ #category : 'accessing' }
DockContextModel >> methodClass [

	^ self entity methodClass
]

{ #category : 'accessing' }
DockContextModel >> methodClassName [

	^ self methodClass name
]

{ #category : 'private' }
DockContextModel >> methodModel [

	^ PvMethodModel 
		newEnvironment: self environmentModel
		entity: self method
]

{ #category : 'accessing' }
DockContextModel >> methodName [

	^ self realMethod selector
]

{ #category : 'accessing' }
DockContextModel >> name [

	^ name ifNil: [ name := self inOneLine ]
]

{ #category : 'accessing' }
DockContextModel >> packageName [

	^ self entity methodClass packageName
]

{ #category : 'debug - actions' }
DockContextModel >> proceedDebugSession [

	self actionModel proceedDebugSession
]

{ #category : 'accessing' }
DockContextModel >> protocolName [

	^  self realMethod protocolName
]

{ #category : 'private - accessing' }
DockContextModel >> realMethod [

	^ self method isCompiledBlock
		ifTrue: [ self method method ]
		ifFalse: [ self method ]
]

{ #category : 'accessing' }
DockContextModel >> resetActionDecorators [

]

{ #category : 'debug - actions' }
DockContextModel >> restartCurrentContext [

	self actionModel restartContext: self entity.
	self flag: #TODO.
	"self clearUnsavedCodeChanges.
	self code text: self currentContext sourceCode.
	self updateCodeFromContext"
]

{ #category : 'debug - actions' }
DockContextModel >> returnValueFromExpression: aString [

	self actionModel 
		returnValueFromExpression: aString
		fromContext: self entity
]

{ #category : 'accessing' }
DockContextModel >> selectedCodeRange [

	^ self session selectedCodeRangeForContext: self context
]

{ #category : 'private - accessing' }
DockContextModel >> session [

	^ self debuggerModel session
]

{ #category : 'accessing' }
DockContextModel >> sourceCode [

	^ self entity sourceCode
]

{ #category : 'debug - actions' }
DockContextModel >> stepInto [

	self actionModel stepInto: self entity.
	self updateEntityFromStack
]

{ #category : 'debug - actions' }
DockContextModel >> stepOver [

	self actionModel stepOver: self entity.
	self updateEntityFromStack
]

{ #category : 'debug - actions' }
DockContextModel >> stepThrough [

	self actionModel stepThrough: self entity.
	self updateEntityFromStack
]

{ #category : 'private' }
DockContextModel >> updateEntityFromStack [
	"I need to update current entity with the stack value when stepping in the 
	 debug, because active context changes.
	 this may be better solved by forcing a model update when updating the stack list, 
	 but for some reason is not working properly at the moment (and this does not hurt, 
	 except that #= and #hash methods will change, creating potential problems if this
	 model is in a hashed collection... which time to time is, as the stack view 
	 *has* one :/)"

	self entity: self session stack first.
	name := nil
]

{ #category : 'updating' }
DockContextModel >> updateWith: aString notifying: anInteractionModel [

	^ self error: 'Should not arrive here.'
]

{ #category : 'updating' }
DockContextModel >> updateWith: aString notifying: anInteractionModel force: aBoolean [
	| result |

	result := self session 
		recompileMethodTo: aString
		inContext: self entity
		notifying: anInteractionModel
		force: aBoolean.
	result ifTrue: [
		self updateEntityFromStack.
		self restartCurrentContext ].

	^ result
]
