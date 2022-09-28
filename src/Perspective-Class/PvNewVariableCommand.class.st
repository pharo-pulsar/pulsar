Class {
	#name : #PvNewVariableCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #initialization }
PvNewVariableCommand >> defineAction [

	self priority: 100.
	self name: 'Add variable'.
	self description: 'Add a variable to current class/trait'.
	self iconComposite: (PvCompositeIcon new 
		name: 'add';
		bottomRight: 'overlayVariable';
		yourself).
	self menuGroup: #action
]
