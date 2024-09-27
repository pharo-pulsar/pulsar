Class {
	#name : 'PvRenamePackageCommand',
	#superclass : 'PvProjectCommand',
	#category : 'Perspective-Project-Command',
	#package : 'Perspective-Project',
	#tag : 'Command'
}

{ #category : 'initialization' }
PvRenamePackageCommand >> defineAction [

	self priority: 200.
	self name: 'Rename'.
	self description: 'Rename package or tag'
]

{ #category : 'executing' }
PvRenamePackageCommand >> execute [
	
	self halt
]
