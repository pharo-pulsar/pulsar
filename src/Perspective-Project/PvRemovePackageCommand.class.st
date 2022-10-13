Class {
	#name : #PvRemovePackageCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project-Command'
}

{ #category : #initialization }
PvRemovePackageCommand >> defineAction [

	self priority: 210.
	self name: 'Remove'.
	self description: 'Remove package or tag (and all its contexts)'.
	self iconCompositeName: 'trash'
]

{ #category : #executing }
PvRemovePackageCommand >> execute [
	
	self halt
]
