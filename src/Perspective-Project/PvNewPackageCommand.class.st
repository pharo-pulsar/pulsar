Class {
	#name : 'PvNewPackageCommand',
	#superclass : 'PvProjectCommand',
	#category : 'Perspective-Project-Command',
	#package : 'Perspective-Project',
	#tag : 'Command'
}

{ #category : 'initialization' }
PvNewPackageCommand >> defineAction [

	self priority: 100.
	self name: 'New package'.
	self description: 'Add a new package to the environment'.
	self iconCompositeName: 'new-file'
]

{ #category : 'executing' }
PvNewPackageCommand >> execute [
	
	context doNewPackage
]
