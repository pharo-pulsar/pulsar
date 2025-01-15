Class {
	#name : 'DockNewProtocolCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockNewProtocolCommand >> defineAction [

	self name: 'New protocol'.
	self description: 'Add a new protocol to this class'.
	self iconCompositeName: 'add'
]

{ #category : 'executing' }
DockNewProtocolCommand >> execute [

	context doAddProtocolCommand: self
]
