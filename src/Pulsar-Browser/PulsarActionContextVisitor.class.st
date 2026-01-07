"
This action visitor helps to set a context to an action group and all its children.
Is useful because we collect actions from different places, but we just can execute them in the context of that specific action (which is the caller presenter, always)
"
Class {
	#name : 'PulsarActionContextVisitor',
	#superclass : 'CmVisitor',
	#instVars : [
		'context'
	],
	#category : 'Pulsar-Browser-Actions',
	#package : 'Pulsar-Browser',
	#tag : 'Actions'
}

{ #category : 'accessing' }
PulsarActionContextVisitor >> context [

	^ context
]

{ #category : 'accessing' }
PulsarActionContextVisitor >> context: aContext [

	context := aContext
]

{ #category : 'visiting' }
PulsarActionContextVisitor >> visitCommand: aCommand [

	^ aCommand 
		context: self context;
		yourself
]

{ #category : 'visiting' }
PulsarActionContextVisitor >> visitCommandGroup: aCommandGroup [

	super visitCommandGroup: aCommandGroup.
	^ aCommandGroup
]
