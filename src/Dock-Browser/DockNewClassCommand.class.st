Class {
	#name : 'DockNewClassCommand',
	#superclass : 'DockProjectCommand',
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'initialization' }
DockNewClassCommand >> defineAction [

	self priority: 110.
	self name: 'New class'.
	self description: 'Add a new class to the environment'.
	self iconCompositeName: 'new-file'
]

{ #category : 'executing' }
DockNewClassCommand >> execute [

	context doRequestNewClass
]
