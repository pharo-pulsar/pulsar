"
This action visitor helps to set a context to an action group and all its children.
Is useful because we collect actions from different places, but we just can execute them in the context of that specific action (which is the caller presenter, always)
"
Class {
	#name : 'DockActionContextVisitor',
	#superclass : 'CmVisitor',
	#instVars : [
		'context'
	],
	#category : 'Dock-Browser-Actions',
	#package : 'Dock-Browser',
	#tag : 'Actions'
}

{ #category : 'accessing' }
DockActionContextVisitor >> context [

	^ context
]

{ #category : 'accessing' }
DockActionContextVisitor >> context: aContext [

	context := aContext
]

{ #category : 'visiting' }
DockActionContextVisitor >> visitCommand: aCommand [

	^ aCommand 
		context: self context;
		yourself
]

{ #category : 'visiting' }
DockActionContextVisitor >> visitCommandGroup: aCommandGroup [

	super visitCommandGroup: aCommandGroup.
	^ aCommandGroup
]
