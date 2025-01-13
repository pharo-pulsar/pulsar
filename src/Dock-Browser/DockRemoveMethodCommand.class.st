Class {
	#name : 'DockRemoveMethodCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockRemoveMethodCommand >> defineAction [
	self name: 'Force remove method'.
	self description: 'Remove this method (without cheching for usages)'
]

{ #category : 'executing' }
DockRemoveMethodCommand >> execute [

	context doForceRemoveMethod
]
