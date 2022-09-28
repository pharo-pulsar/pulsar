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
	self iconCompositeName: 'openProject'.
	self menuGroup: #project.
	self toolbarGroup: #project
]

{ #category : #executing }
PvOpenProjectCommand >> execute [
	
	context doOpenProject
]
