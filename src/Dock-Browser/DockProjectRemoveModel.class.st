Class {
	#name : 'DockProjectRemoveModel',
	#superclass : 'DockModelVisitor',
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'visiting' }
DockProjectRemoveModel >> visitProjectModel: aModel [

	self owner removeProjectModel: aModel
]
