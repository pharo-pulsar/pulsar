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
	
	self context saveImage
]
