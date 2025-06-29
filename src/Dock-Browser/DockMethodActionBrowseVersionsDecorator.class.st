Class {
	#name : 'DockMethodActionBrowseVersionsDecorator',
	#superclass : 'PvMethodActionDecorator',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'testing' }
DockMethodActionBrowseVersionsDecorator class >> appliesTo: aMethod [

	^ true
]

{ #category : 'initialization' }
DockMethodActionBrowseVersionsDecorator >> defineAction [

	self name: 'Versions'.
	self description: 'Browse versions of current method.'.
	self iconCompositeName: 'versions'
]

{ #category : 'executing' }
DockMethodActionBrowseVersionsDecorator >> execute [

	self context doBrowseVersionsCommand: self
]
