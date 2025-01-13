Class {
	#name : 'DockNewVariableCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockNewVariableCommand >> defineAction [

	self name: 'New variable'.
	self description: 'Add a new variable to this class'.
	self iconCompositeName: 'add'
]

{ #category : 'executing' }
DockNewVariableCommand >> execute [

	context doAddVariable
]
