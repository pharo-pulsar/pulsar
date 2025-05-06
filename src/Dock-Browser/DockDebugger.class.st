Class {
	#name : 'DockDebugger',
	#superclass : 'DockBaseBrowser',
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'instance creation' }
DockDebugger >> debugSession: aDebugSession [
	logger trace: aDebugSession.
	self session: aDebugSession.
	self open
]

{ #category : 'initialization' }
DockDebugger >> initializeWorkspace [

	self startWidth: 380.
	
	
]

{ #category : 'accessing' }
DockDebugger >> session: aDebugSession [

	logger trace: aDebugSession.
	self model: (DockDebuggerModel on: aDebugSession)
]
