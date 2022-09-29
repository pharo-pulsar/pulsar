Class {
	#name : #PvNewPackageTagCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #initialization }
PvNewPackageTagCommand >> defineAction [

	self priority: 101.
	self name: 'New tag'.
	self description: 'Add a new tag to this package'.
	self iconCompositeName: 'new-file'
]

{ #category : #executing }
PvNewPackageTagCommand >> execute [
	
	context doNewPackage
]
