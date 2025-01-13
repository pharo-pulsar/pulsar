Class {
	#name : 'DockRemoveVariableCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockRemoveVariableCommand >> defineAction [

	self name: 'Force remove method'.
	self description: 'Remove this method (without cheching for usages)'
]

{ #category : 'executing' }
DockRemoveVariableCommand >> execute [

	context doForceRemoveMethod
]
