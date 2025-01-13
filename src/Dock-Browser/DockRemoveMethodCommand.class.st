Class {
	#name : 'DockRemoveMethodCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockRemoveMethodCommand >> defineAction [

	self name: 'Remove variable'.
	self description: 'Remove this variable'
]

{ #category : 'executing' }
DockRemoveMethodCommand >> execute [

	context doRemoveVariable
]
