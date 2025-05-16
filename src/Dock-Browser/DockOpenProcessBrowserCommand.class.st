Class {
	#name : 'DockOpenProcessBrowserCommand',
	#superclass : 'DockToolCommand',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'initialization' }
DockOpenProcessBrowserCommand >> defineAction [

	self name: 'Open Process Browser'.
	self description: 'Open the process browser'
]

{ #category : 'executing' }
DockOpenProcessBrowserCommand >> execute [

	self context spawnNewProcessBrowser
]
