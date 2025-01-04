Class {
	#name : 'DockCategoriseMethodCommand',
	#superclass : 'PvMethodEditorCommand',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
DockCategoriseMethodCommand >> defineAction [

	self name: 'Classify method'.
	self description: 'Change protocol of current method'.
	self iconCompositeName: 'tag'
]

{ #category : 'executing' }
DockCategoriseMethodCommand >> execute [

	context doRequestChangeProtocol
]
