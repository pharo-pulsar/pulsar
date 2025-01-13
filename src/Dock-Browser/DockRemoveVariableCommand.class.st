Class {
	#name : 'DockRemoveVariableCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockRemoveVariableCommand >> defineAction [

	self name: 'Remove variable'.
	self description: 'Remove this variable'
]

{ #category : 'executing' }
DockRemoveVariableCommand >> execute [

	context doRemoveVariable
]
