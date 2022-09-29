Class {
	#name : #PvRenamePackageCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #initialization }
PvRenamePackageCommand >> defineAction [

	self priority: 200.
	self name: 'Rename'.
	self description: 'Rename package or tag'
]

{ #category : #executing }
PvRenamePackageCommand >> execute [
	
	self halt
]
