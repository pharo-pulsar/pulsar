Class {
	#name : #PvRefreshProjectCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #initialization }
PvRefreshProjectCommand >> defineAction [

	self priority: 10.
	self name: 'Refresh project'.
	self description: 'Refresh this project (reload configuration)'.
	self iconCompositeName: 'refresh'
]

{ #category : #executing }
PvRefreshProjectCommand >> execute [
	
	context refreshProject
]
