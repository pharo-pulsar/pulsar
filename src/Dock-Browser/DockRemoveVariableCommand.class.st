Class {
	#name : 'DockRemoveVariableCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockRemoveVariableCommand >> defineAction [

	self name: 'Remove slot'.
	self description: 'Remove this slot'
]

{ #category : 'executing' }
DockRemoveVariableCommand >> execute [

	context doRemoveVariable
]
