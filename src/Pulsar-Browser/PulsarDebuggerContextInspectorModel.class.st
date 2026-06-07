"
I am an inspector model that wraps a Context and maps its numbered temporary variables to their actual names defined in the method.

I override allModelInspectorNodes to build named inspector nodes using Context>>temporaryVariableNames, which queries the compiler AST through OnlineSourceDebugInfo to resolve variable names at the current bytecode position.

My node list follows the StDebuggerContext>>buildInspectorNodes pattern: self, named arguments, named temporaries, receiver variables, stack top, and thisContext.
"
Class {
	#name : 'PulsarDebuggerContextInspectorModel',
	#superclass : 'StInspectorModel',
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'accessing' }
PulsarDebuggerContextInspectorModel >> allModelInspectorNodes [
	"Build named inspector nodes mapping Context temp indexes to method variable names."

	| nodes tempsAndArgs argsNodes tempsNodes |
	nodes := OrderedCollection new.
	tempsAndArgs := self temporaryVariablesNodes.
	argsNodes := tempsAndArgs select: [ :each | each isArgumentVariable ].
	tempsNodes := tempsAndArgs select: [ :each | each isTempVariable ].
	nodes add: self selfNode.
	nodes addAll: argsNodes.
	nodes addAll: tempsNodes.
	nodes addAll: self receiverNodes.
	nodes add: self stackTopNode.
	nodes add: self thisContextNode.
	^ nodes
]

{ #category : 'accessing' }
PulsarDebuggerContextInspectorModel >> context [

	^ inspectedObject
]

{ #category : 'nodes' }
PulsarDebuggerContextInspectorModel >> receiverNodes [

	^ self context receiver allInspectorNodes reject: [ :each | each label = 'self' ]
]

{ #category : 'nodes' }
PulsarDebuggerContextInspectorModel >> selfNode [

	^ StInspectorSelfNode hostObject: (self context home ifNotNil: [ :home | home receiver ])
]

{ #category : 'nodes' }
PulsarDebuggerContextInspectorModel >> stackTopNode [

	^ StInspectorStackTopNode hostObject: self context
]

{ #category : 'nodes' }
PulsarDebuggerContextInspectorModel >> temporaryVariablesNodes [

	^ self context temporaryVariableNames collect: [ :each | (StInspectorTempNode hostObject: self context) tempName: each ]
]

{ #category : 'nodes' }
PulsarDebuggerContextInspectorModel >> thisContextNode [

	^ StInspectorThisContextNode hostObject: self context
]
