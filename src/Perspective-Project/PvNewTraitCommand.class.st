Class {
	#name : #PvNewTraitCommand,
	#superclass : #PvProjectCommand,
	#category : #'Perspective-Project'
}

{ #category : #initialization }
PvNewTraitCommand >> defineAction [

	self priority: 120.
	self name: 'New trait'.
	self description: 'Add a new trait to the environment'.
	self iconCompositeName: 'new-file'.
	self menuGroup: #actionNew.
	self toolbarGroup: #actionNew
]

{ #category : #executing }
PvNewTraitCommand >> execute [
	
	context doNewTrait
]
