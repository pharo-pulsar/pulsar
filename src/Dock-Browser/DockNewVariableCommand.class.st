Class {
	#name : 'DockNewVariableCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockNewVariableCommand >> defineAction [

	self name: 'New slot'.
	self description: 'Add a new slot to this class'.
	self iconCompositeName: 'add'
]

{ #category : 'executing' }
DockNewVariableCommand >> execute [

	context doAddVariableCommand: self
]
