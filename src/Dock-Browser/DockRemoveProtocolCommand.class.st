Class {
	#name : 'DockRemoveProtocolCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'initialization' }
DockRemoveProtocolCommand >> defineAction [

	self name: 'Remove protocol'.
	self description: 'Remove this protocol and all its methods?'
]

{ #category : 'executing' }
DockRemoveProtocolCommand >> execute [

	context doRemoveSelectedProtocol
]
