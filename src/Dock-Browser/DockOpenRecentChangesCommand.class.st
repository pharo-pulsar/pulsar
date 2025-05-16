Class {
	#name : 'DockOpenRecentChangesCommand',
	#superclass : 'DockToolCommand',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'initialization' }
DockOpenRecentChangesCommand >> defineAction [

	self name: 'Open Recent Changes'.
	self description: 'Open recent changes log.'.
	self priority: 910
]

{ #category : 'executing' }
DockOpenRecentChangesCommand >> execute [

	self context spawnRecentChanges
]
