Class {
	#name : 'DockOpenBrowserCommand',
	#superclass : 'DockToolCommand',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'initialization' }
DockOpenBrowserCommand >> defineAction [

	self name: 'Open Browser'.
	self description: 'Spawn a new browser'
]

{ #category : 'executing' }
DockOpenBrowserCommand >> execute [
	
	self context spawnNewBrowser
]
