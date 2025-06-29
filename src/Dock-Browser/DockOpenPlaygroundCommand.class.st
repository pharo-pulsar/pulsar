Class {
	#name : 'DockOpenPlaygroundCommand',
	#superclass : 'DockToolCommand',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'initialization' }
DockOpenPlaygroundCommand >> defineAction [

	self name: 'New Playground'.
	self description: 'Open a new playground in your browser'
]

{ #category : 'executing' }
DockOpenPlaygroundCommand >> execute [

	self context openPlayground
]
