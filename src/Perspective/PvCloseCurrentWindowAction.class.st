Class {
	#name : 'PvCloseCurrentWindowAction',
	#superclass : 'PvAction',
	#category : 'Perspective-Command-Actions',
	#package : 'Perspective',
	#tag : 'Command-Actions'
}

{ #category : 'initialization' }
PvCloseCurrentWindowAction >> defineAction [

	self name: 'Close window'.
	self description: 'Close window with current focus (if closeable)'
]

{ #category : 'executing' }
PvCloseCurrentWindowAction >> execute [
	
	self context close
]
