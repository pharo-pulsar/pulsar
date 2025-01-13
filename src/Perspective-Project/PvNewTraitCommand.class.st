Class {
	#name : 'PvNewTraitCommand',
	#superclass : 'PvProjectCommand',
	#category : 'Perspective-Project-Command',
	#package : 'Perspective-Project',
	#tag : 'Command'
}

{ #category : 'initialization' }
PvNewTraitCommand >> defineAction [

	self priority: 120.
	self name: 'New trait'.
	self description: 'Add a new trait to the environment'.
	self iconCompositeName: 'new-file'
]

{ #category : 'executing' }
PvNewTraitCommand >> execute [
	
	context doRequestNewTrait
]
