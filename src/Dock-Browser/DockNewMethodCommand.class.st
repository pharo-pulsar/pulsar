Class {
	#name : 'DockNewMethodCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockNewMethodCommand >> defineAction [

	self name: 'New method'.
	self description: 'Add a new method to this class'.
	self iconCompositeName: 'add'
]

{ #category : 'executing' }
DockNewMethodCommand >> execute [

	context doRequestNewMethod
]
