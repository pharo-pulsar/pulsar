Class {
	#name : 'PulsarContextModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'name',
		'debuggerModel',
		'topContext',
		'contextPredicate'
	],
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'instance creation' }
PulsarContextModel class >> newEnvironment: anEnvironmentModel debuggerModel: aDebuggerModel context: aContext [

	^ (self newEnvironment: anEnvironmentModel entity: aContext)
		debuggerModel: aDebuggerModel;
		yourself
]

{ #category : 'comparing' }
PulsarContextModel >> = other [

	self species = other species ifFalse: [ ^ false ].
	^ self entity = other entity
]

{ #category : 'accessing' }
PulsarContextModel >> actionDecorators [

	^ self actions actionsFor: #decoration
]

{ #category : 'private - accessing' }
PulsarContextModel >> actionModel [

	^ self debuggerModel actionModel
]

{ #category : 'accessing - actions' }
PulsarContextModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: 'operations') 
		copyWithContext: aContextPresenter
]

{ #category : 'converting' }
PulsarContextModel >> asClassModel [

	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self methodClass
]

{ #category : 'converting' }
PulsarContextModel >> asOutlineClassModel [
	
	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self methodClass
]

{ #category : 'testing' }
PulsarContextModel >> canExecuteCreateMissingClassCommand [

	^ false "self session isInterruptedContextMissingClassException"
]

{ #category : 'testing' }
PulsarContextModel >> canExecuteCreateMissingMethodCommand [

	^ self session isInterruptedContextDoesNotUnderstand
]

{ #category : 'debug - testing' }
PulsarContextModel >> canExecuteDebugCommand [

	^ self actionModel isContextSteppable
]

{ #category : 'debug - testing' }
PulsarContextModel >> canExecuteRestartCommand [

	^ (self actionModel isInterruptedContextPostMortem 
		or: [ self actionModel isInterruptedContextDead ]) not
]

{ #category : 'debug - testing' }
PulsarContextModel >> canExecuteReturnCommand [

	^ self actionModel isInterruptedContextDead not
]

{ #category : 'private' }
PulsarContextModel >> computeInitialTopContext [
	| context |

	context := self session exception signalContext.
	context 
		ifNil: [ ^ self entity ].
		
	(context hasContext: self entity) 
		ifFalse: [ ^ self entity ].
		
	^ context
]

{ #category : 'accessing' }
PulsarContextModel >> context [

	"a synonym for clarity"
	^ self entity
]

{ #category : 'private - accessing' }
PulsarContextModel >> contextPredicate [

	^ contextPredicate ifNil: [ 
		  contextPredicate := self updateContextPredicateFor: self topContext ]
]

{ #category : 'private' }
PulsarContextModel >> contextPredicateFor: aContext [
	| postMortem ex |
	
	postMortem := self isContextPostMortem: aContext.

	(self contextSignalsAnException: aContext) ifFalse: [ 
		^ self predicateFor: aContext postMortem: postMortem ].

	ex := aContext receiver.
	(ex isKindOf: TestFailure) ifTrue: [ 
		^ self predicateFor: aContext failure: ex postMortem: postMortem ].

	^ self predicateFor: aContext exception: ex postMortem: postMortem
]

{ #category : 'private - accessing' }
PulsarContextModel >> debuggerModel [

	^ debuggerModel
]

{ #category : 'initialization' }
PulsarContextModel >> debuggerModel: aDebuggerModel [

	debuggerModel := aDebuggerModel
]

{ #category : 'private - definitions' }
PulsarContextModel >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #operations with: [ :group | 
		"create class if needed"
		self canExecuteCreateMissingClassCommand ifTrue: [
			group addActionWith: [ :action | action 
				name: 'Create Class'; 
				iconName: 'add';
				action: [ :aContext | aContext doImplementMissingClass ] ] ].
		"create method if needed"
		self canExecuteCreateMissingMethodCommand ifTrue: [
			group addActionWith: [ :action | action 
				name: 'Create Method'; 
				iconName: 'add';
				action: [ :aContext | aContext doImplementMissingMethod ] ] ] 
	]
]

{ #category : 'accessing' }
PulsarContextModel >> fullName [

	^ self name
]

{ #category : 'comparing' }
PulsarContextModel >> hash [

	^ self species hash bitXor: self entity
]

{ #category : 'private' }
PulsarContextModel >> inOneLine [
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

{ #category : 'testing' }
PulsarContextModel >> isContextModel [

	^ true
]

{ #category : 'testing' }
PulsarContextModel >> isNew [

	^ false
]

{ #category : 'testing' }
PulsarContextModel >> isSameClass: aClass [

	^ self methodClass instanceSide = aClass instanceSide
]

{ #category : 'accessing' }
PulsarContextModel >> method [

	^ self entity method
]

{ #category : 'accessing' }
PulsarContextModel >> methodClass [

	^ self entity methodClass
]

{ #category : 'accessing' }
PulsarContextModel >> methodClassName [

	^ self methodClass name
]

{ #category : 'private' }
PulsarContextModel >> methodModel [

	^ PvMethodModel 
		newEnvironment: self environmentModel
		entity: self method
]

{ #category : 'accessing' }
PulsarContextModel >> methodName [

	^ self realMethod selector
]

{ #category : 'accessing' }
PulsarContextModel >> name [

	^ name ifNil: [ name := self inOneLine ]
]

{ #category : 'updating' }
PulsarContextModel >> newMethodInteractionModel [

	^ SpCodeMethodInteractionModel on: self method
]

{ #category : 'accessing' }
PulsarContextModel >> packageName [

	^ self entity methodClass packageName
]

{ #category : 'debug - actions' }
PulsarContextModel >> proceedDebugSession [

	self actionModel proceedDebugSession
]

{ #category : 'accessing' }
PulsarContextModel >> protocolName [

	^  self realMethod protocolName
]

{ #category : 'private - accessing' }
PulsarContextModel >> realMethod [

	^ self method isCompiledBlock
		ifTrue: [ self method method ]
		ifFalse: [ self method ]
]

{ #category : 'accessing' }
PulsarContextModel >> resetActionDecorators [

]

{ #category : 'debug - actions' }
PulsarContextModel >> restartCurrentContext [

	self actionModel restartContext: self entity.
	self flag: #TODO.
	"self clearUnsavedCodeChanges.
	self code text: self currentContext sourceCode.
	self updateCodeFromContext"
]

{ #category : 'debug - actions' }
PulsarContextModel >> returnValueFromExpression: aString [

	self actionModel 
		returnValueFromExpression: aString
		fromContext: self entity
]

{ #category : 'accessing' }
PulsarContextModel >> selectedCodeRange [

	^ self session selectedCodeRangeForContext: self context
]

{ #category : 'private - accessing' }
PulsarContextModel >> session [

	^ self debuggerModel session
]

{ #category : 'accessing' }
PulsarContextModel >> sourceCode [

	^ self entity sourceCode
]

{ #category : 'debug - actions' }
PulsarContextModel >> stepInto [

	self actionModel stepInto: self entity.
	self updateEntityFromStack
]

{ #category : 'debug - actions' }
PulsarContextModel >> stepOver [

	self actionModel stepOver: self entity.
	self updateEntityFromStack
]

{ #category : 'debug - actions' }
PulsarContextModel >> stepThrough [

	self actionModel stepThrough: self entity.
	self updateEntityFromStack
]

{ #category : 'private - accessing' }
PulsarContextModel >> topContext [

	^ topContext ifNil: [ topContext := self computeInitialTopContext ]
]

{ #category : 'private' }
PulsarContextModel >> updateContextPredicateFor: aContext [

	contextPredicate := self contextPredicateFor: aContext.
	^ contextPredicate
]

{ #category : 'private' }
PulsarContextModel >> updateEntityFromStack [
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
PulsarContextModel >> updateWith: aString notifying: anInteractionModel force: aBoolean [
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
