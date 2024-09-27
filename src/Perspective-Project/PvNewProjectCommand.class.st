Class {
	#name : 'PvNewProjectCommand',
	#superclass : 'PvProjectCommand',
	#category : 'Perspective-Project-Command',
	#package : 'Perspective-Project',
	#tag : 'Command'
}

{ #category : 'initialization' }
PvNewProjectCommand >> defineAction [

	self priority: 0.
	self name: 'New project'.
	self description: 'New project'.
	self iconCompositeName: 'new-folder'
]

{ #category : 'executing' }
PvNewProjectCommand >> execute [
	
	
]
