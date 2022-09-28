Class {
	#name : #PvNewClassMethodCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #initialization }
PvNewClassMethodCommand >> defineAction [

	self priority: 20.
	self name: 'Add class method'.
	self description:  'Add a method (class side) to current class/trait'.
	self iconComposite: (PvCompositeIcon new 
		name: 'add';
		bottomRight: 'overlayMethod';
		yourself).
	self menuGroup: #action
]
