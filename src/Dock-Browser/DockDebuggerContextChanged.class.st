Class {
	#name : 'DockDebuggerContextChanged',
	#superclass : 'DockAnnouncement',
	#instVars : [
		'updateTopContext'
	],
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'initialization' }
DockDebuggerContextChanged >> initialize [

	super initialize.
	updateTopContext := false
]

{ #category : 'testing' }
DockDebuggerContextChanged >> isUpdateTopContext [

	^ updateTopContext
]

{ #category : 'accessing' }
DockDebuggerContextChanged >> updateTopContext: aBoolean [

	updateTopContext := aBoolean
]
