Class {
	#name : 'DockImageSaveCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'initialization' }
DockImageSaveCommand >> defineAction [

	self name: 'Save'.
	self description: 'Save this image'
]

{ #category : 'executing' }
DockImageSaveCommand >> execute [

	[ Smalltalk snapshot: true andQuit: false ] fork.
	self context inform: 'Image saved'
]
