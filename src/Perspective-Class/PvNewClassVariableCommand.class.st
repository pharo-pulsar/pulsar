Class {
	#name : #PvNewClassVariableCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #initialization }
PvNewClassVariableCommand >> defineAction [

	self priority: 110.
	self name: 'Add class variable'.
	self description: 'Add a variable (class side) to current class/trait'.
	self iconComposite: (PvCompositeIcon new 
		name: 'add';
		topRight: 'overlayClass';
		bottomRight: 'overlayVariable';
		yourself).
	self menuGroup: #action
]
