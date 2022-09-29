Class {
	#name : #PvOpenProjectCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #initialization }
PvOpenProjectCommand >> defineAction [

	self priority: 1.
	self name: 'Open project'.
	self description: 'Open project'.
	self iconCompositeName: 'openProject'
]

{ #category : #executing }
PvOpenProjectCommand >> execute [
	
	context doOpenProject
]
