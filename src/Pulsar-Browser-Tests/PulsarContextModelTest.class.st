"
A test for PulsarContextModel, focused on the conditions in which the code of a debugged context can be saved as a new version of its method (canBeSaved).
"
Class {
	#name : 'PulsarContextModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarContextModelTest >> newContextModelFor: aSession context: aContext [

	^ PulsarContextModel
		  newEnvironment: PvEnvironmentModel onSystem
		  debuggerModel: (PulsarDebuggerModel on: aSession)
		  context: aContext
]

{ #category : 'tests' }
PulsarContextModelTest >> testCannotBeCompiledBlockContextWithHome [
	| provider session context model reached |
	
	provider := StTestDebuggerProvider new.
	session := provider sessionWithInlinedLoop.
	context := session interruptedContext.
	reached := false.
	1000 timesRepeat: [
			(context isNotNil and: [ context isBlockContext ]) ifTrue: [
					reached := true.
					^ self ].
			session stepInto.
			context := session interruptedContext ].
	self assert: reached description: 'could not reach a block context'.
	model := self newContextModelFor: session context: context.

	self assert: model canBeCompiled
]

{ #category : 'tests' }
PulsarContextModelTest >> testCannotBeCompiledBlockContextWithoutHome [

	| provider session context model |
	provider := StTestDebuggerProvider new.
	session := provider sessionForDebuggerTests.
	context := session interruptedContext.
	model := self newContextModelFor: session context: context.

	self assert: context isBlockContext.
	self deny: model canBeCompiled.
	self assert: model canNotBeCompiledReason equals: 'The home of this block is not in the stack'
]

{ #category : 'tests' }
PulsarContextModelTest >> testCannotBeCompiledDeadContext [

	| provider session semaphore process context model reached |
	semaphore := Semaphore new.
	process := [ semaphore wait ] newProcess.
	process resume.
	reached := false.
	10000 timesRepeat: [
			process suspendedContext isNotNil ifTrue: [
					reached := true.
					^ self ].
			Processor yield ].
	self assert: reached description: 'process did not reach the semaphore wait'.
	context := process suspendedContext.
	process terminate.

	provider := StTestDebuggerProvider new.
	session := provider sessionForDebuggerTests.
	model := self newContextModelFor: session context: context.

	self assert: context isDead.
	self deny: model canBeCompiled.
	self assert: model canNotBeCompiledReason equals: 'The context is dead'
]

{ #category : 'tests' }
PulsarContextModelTest >> testCannotBeCompiledMethodContext [

	| provider session context model |
	provider := StTestDebuggerProvider new.
	[ StDebuggerObjectForTests new haltingMethod ]
		on: Halt
		do: [ :err | provider sessionFor: err signalerContext exception: err ].
	session := provider session.
	context := session interruptedContext.
	model := self newContextModelFor: session context: context.

	self assert: context isBlockContext not.
	self assert: model canBeCompiled
]

{ #category : 'tests' }
PulsarContextModelTest >> testCannotBeCompiledPostMortemSession [

	| semaphore process context session model reached |
	semaphore := Semaphore new.
	process := [ semaphore wait ] newProcess.
	process resume.
	reached := false.
	10000 timesRepeat: [
			process suspendedContext isNotNil ifTrue: [
					reached := true.
					^ self ].
			Processor yield ].
	self assert: reached description: 'process did not reach the semaphore wait'.
	context := process suspendedContext.
	process terminate.
	session := DebugSession named: 'PulsarContextModelTest post mortem' on: process startedAt: context.
	session exception: (OupsNullException fromSignallerContext: context).
	model := self newContextModelFor: session context: context.

	self assert: model canBeCompiled
]
